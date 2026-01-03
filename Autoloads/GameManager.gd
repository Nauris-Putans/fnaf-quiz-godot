extends Node

signal game_won
signal game_lost
signal question_changed(question_text: String)
signal answers_changed(answers: Array[String])
signal answered_question_count(index: int)

var current_question: int = 0
var question_array: Array = [
	{
		"question": "Who is the main animatronic mascot of Freddy Fazbear’s Pizza?",
		"answers": ["Freddy Fazbear", "Bonnie", "Chica", "Foxy"],
		"correct": 0,
	},
	{
		"question": "What time do you need to survive until to win a night in FNAF 1?",
		"answers": ["5:00 AM", "6:00 AM", "7:00 AM", "Midnight"],
		"correct": 1,
	},
	{
		"question": "What runs out if you use the doors and lights too much?",
		"answers": ["Camera signal", "Oxygen", "Power", "Battery for flashlight"],
		"correct": 2,
	},
	{
		"question": "Which animatronic hides in Pirate Cove?",
		"answers": ["Bonnie", "Freddy", "Chica", "Foxy"],
		"correct": 3,
	},
	{
		"question": "What tool do you mainly use to watch animatronics?",
		"answers": ["Flashlight", "Security cameras", "Radar", "Motion sensor"],
		"correct": 1,
	},
	{
		"question": "Which animatronic is known for banging on the left door?",
		"answers": ["Chica", "Bonnie", "Freddy", "Foxy"],
		"correct": 1,
	},
	{
		"question": "Which animatronic uses the right door?",
		"answers": ["Bonnie", "Freddy", "Chica", "Golden Freddy"],
		"correct": 2,
	},
	{
		"question": "What happens if Foxy reaches your office?",
		"answers": ["Nothing", "You lose power", "Instant jumpscare", "Night ends"],
		"correct": 2,
	},
	{
		"question": "How many nights are in the main game (without custom night)?",
		"answers": ["4", "5", "6", "7"],
		"correct": 2,
	},
	{
		"question": "Where does the night guard sit during the game?",
		"answers": ["Dining area", "Stage", "Security office", "Back room"],
		"correct": 2,
	},
]


func start_run() -> void:
	Engine.time_scale = 1
	current_question = 0
	_randomize_questions()
	_emit_current()

func randomize_questions_and_emit_current() -> void:
	print("randomize_questions")	
	randomize()
	question_array.shuffle()
	_emit_current()

func _randomize_questions() -> void:
	randomize()
	question_array.shuffle()


func player_answer(index: int) -> void:
	var correct: int = question_array[current_question].get("correct", -1)

	if index == correct:
		current_question += 1

		if current_question >= question_array.size():
			game_won.emit()
			return

		_emit_current()
	else:
		game_lost.emit()


func _emit_current() -> void:
	var question = str(question_array[current_question].get("question", ""))
	var answer = question_array[current_question].get("answers", [])
	question_changed.emit(question)
	answers_changed.emit(answer)
	answered_question_count.emit(current_question)
