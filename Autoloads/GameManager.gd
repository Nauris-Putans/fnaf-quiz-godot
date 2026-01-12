extends Node

signal game_won
signal game_lost
signal question_changed(question_text: String)
signal answers_changed(answers: Array[String])
signal answered_question_count(index: int)
signal determine_question_timer
signal difficulty_changed(difficulty: String)
signal allowed_strikes_changed(allowed_strikes_count: int)
signal correctly_answered_changed(correctly_answered_count: int)
signal wrongly_answered_changed(wrongly_answered_count: int)
signal camera_shake_amount(amount: float)

const QuestionBank = preload("res://Data/questions.gd")

var question_array: Array = QuestionBank.ALL

var allowed_strikes: int = 3
var current_wrong_answers = 0
var current_question: int = 0
var current_hour: int = 0
var current_correct_answers: int = 0
var difficulty = "easy"

var _rng := RandomNumberGenerator.new()
var shuffle_answers_each_question := true # you can toggle this later

var current_question_data: Dictionary = { }
var questions_answered: int = 0
var run_over: bool = false

var high_score: int = 0
var current_score: int = 0
var time_bonus_points: int = 0 # accumulated during the run: +10 per second remaining

# pools of indices into question_array (no repeats because we pop)
var pools: Dictionary = {
	"easy": [],
	"medium": [],
	"hard": [],
}


func start_run() -> void:
	Engine.time_scale = 1
	reset_all_values()
	_randomize_allowed_strikes_count()
	run_over = false
	questions_answered = 0
	randomize()
	_rng.randomize()
	_build_question_pools()
	_emit_current()


func reset_all_values() -> void:
	allowed_strikes = 1
	current_wrong_answers = 0
	current_correct_answers = 0
	current_question = 0
	current_hour = 0
	difficulty = "easy"
	time_bonus_points = 0


func _randomize_allowed_strikes_count() -> void:
	var random_number = randi_range(0, 99)

	if random_number <= 14:
		allowed_strikes = 1
	elif random_number <= 44:
		allowed_strikes = 2
	elif random_number <= 84:
		allowed_strikes = 3
	else:
		allowed_strikes = 4


func _build_question_pools() -> void:
	pools["easy"].clear()
	pools["medium"].clear()
	pools["hard"].clear()

	for index in range(question_array.size()):
		var question: Dictionary = question_array[index]
		var diff := String(question.get("difficulty", "easy"))

		if pools.has(diff):
			pools[diff].append(index)
		else:
			# If something is misspelled like "eazy", fall back to easy but warn.
			push_warning("Unknown difficulty '%s' on question index %d. Defaulting to easy." % [diff, index])
			pools["easy"].append(index)

	pools["easy"].shuffle()
	pools["medium"].shuffle()
	pools["hard"].shuffle()


func _emit_question_by_index(q_index: int) -> void:
	current_question_data = question_array[q_index]

	var question := String(current_question_data.get("question", ""))
	var answers: Array[String] = []

	var raw_any: Variant = current_question_data.get("answers", [])
	if raw_any is Array:
		for a in raw_any:
			answers.append(String(a))

	question_changed.emit(question)
	answers_changed.emit(answers)
	determine_question_timer.emit()
	difficulty_changed.emit(determnie_game_difficulty_based_on_current_hour())
	allowed_strikes_changed.emit(allowed_strikes)
	answered_question_count.emit(questions_answered)


func randomize_questions_and_emit_current() -> void:
	if run_over:
		return

	var diff := determnie_game_difficulty_based_on_current_hour()
	var pool: Array = pools.get(diff, [])

	if pool.is_empty():
		push_warning("No more '%s' questions left." % diff)
		return

	# Pick random element from remaining pool (still no repeats)
	var pick_i: int = randi_range(0, pool.size() - 1)
	var q_index: int = int(pool.pop_at(pick_i))
	pools[diff] = pool

	_emit_question_by_index(q_index)


func _shuffle_answers_keep_correct(q: Dictionary) -> Dictionary:
	var out := q.duplicate(true) # deep copy so we don't mutate the bank

	var answers_any: Variant = out.get("answers", [])
	if not (answers_any is Array):
		return out

	var answers: Array = answers_any
	var correct_index: int = int(out.get("correct", -1))
	if answers.size() < 2 or correct_index < 0 or correct_index >= answers.size():
		return out

	# Build [text, is_correct] pairs
	var paired: Array = []
	for i in range(answers.size()):
		paired.append([String(answers[i]), i == correct_index])

	# Fisher–Yates shuffle with our RNG
	for i in range(paired.size() - 1, 0, -1):
		var j := _rng.randi_range(0, i)
		var tmp = paired[i]
		paired[i] = paired[j]
		paired[j] = tmp

	# Rebuild answers + find new correct
	var new_answers: Array = []
	var new_correct := -1
	for i in range(paired.size()):
		new_answers.append(paired[i][0])
		if paired[i][1]:
			new_correct = i

	out["answers"] = new_answers
	out["correct"] = new_correct
	return out


func finalize_run(won: bool) -> void:
	var base_points := current_correct_answers * 100
	var perfect_bonus := 500 if current_wrong_answers == 0 else 0

	current_score = base_points + time_bonus_points + perfect_bonus

	if current_score > high_score:
		high_score = current_score

	# Store for end screen
	set_meta("high_score", high_score)
	set_meta("last_result", won)
	set_meta("last_score", current_score)
	set_meta("last_questions_answered", questions_answered)
	set_meta("last_correct_answered", current_correct_answers)
	set_meta("last_correct", current_correct_answers)
	set_meta("last_wrong", current_wrong_answers)
	set_meta("last_time_bonus", time_bonus_points)
	set_meta("last_perfect_bonus", perfect_bonus)


func on_hour_changed(hour: int) -> void:
	current_hour = hour

	if run_over:
		return

	if current_hour >= 6:
		run_over = true
		finalize_run(true)
		game_won.emit()


func lose_game() -> void:
	game_lost.emit()


func _get_questions_by_difficulty() -> Array:
	return question_array.filter(
		func(element):
			return element["difficulty"] == determnie_game_difficulty_based_on_current_hour()
	)


func determine_camera_shake_amount() -> float:
	return clamp(0.25 + 0.15 * float(current_wrong_answers), 0.25, 0.7)


func player_answer(index: int, seconds_remaining: int = 0) -> void:
	if run_over:
		return

	var correct: int = int(current_question_data.get("correct", -1))
	questions_answered += 1

	if index == correct:
		AudioManager.play("Correct")
		current_correct_answers += 1
		correctly_answered_changed.emit(current_correct_answers)

		# Time bonus
		var secs := int(ceil(max(seconds_remaining, 0.0)))
		time_bonus_points += secs * 10

		_emit_current()
		return

	AudioManager.play("Incorrect")
	current_wrong_answers += 1
	wrongly_answered_changed.emit(current_wrong_answers)
	camera_shake_amount.emit(determine_camera_shake_amount())

	if current_wrong_answers >= allowed_strikes:
		run_over = true
		finalize_run(false)
		game_lost.emit()
		return


func next_question() -> void:
	_emit_current()


func determnie_game_difficulty_based_on_current_hour() -> String:
	if current_hour <= 1:
		return "easy"
	if current_hour <= 3:
		return "medium"

	return "hard"


func _emit_current() -> void:
	if run_over:
		return

	var diff := determnie_game_difficulty_based_on_current_hour()
	var pool: Array = pools.get(diff, [])

	if pool.is_empty():
		# Strict "no repeats": if you run out, just stop asking questions.
		# The clock can still run until hour 6.
		push_warning("No more '%s' questions left (no repeats). Add more questions or reduce question frequency." % diff)
		return

	# Pop next unique question
	var q_index: int = int(pool.pop_back())
	pools[diff] = pool

	var raw_q: Dictionary = question_array[q_index]
	current_question_data = _shuffle_answers_keep_correct(raw_q) if shuffle_answers_each_question else raw_q

	var question := String(current_question_data.get("question", ""))
	var answers: Array[String] = []

	var raw_any: Variant = current_question_data.get("answers", [])
	if raw_any is Array:
		for a in raw_any:
			answers.append(String(a))

	question_changed.emit(question)
	answers_changed.emit(answers)
	determine_question_timer.emit()
	difficulty_changed.emit(diff)
	allowed_strikes_changed.emit(allowed_strikes)
	answered_question_count.emit(questions_answered)
