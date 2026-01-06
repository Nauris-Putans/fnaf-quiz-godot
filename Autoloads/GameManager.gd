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

var question_array: Array = [
	# --- EASY (1–18) ---
	{
		"question": "Who is the main animatronic mascot of Freddy Fazbear’s Pizza?",
		"answers": ["Bonnie", "Chica", "Freddy Fazbear", "Foxy"],
		"correct": 2,
		"difficulty": "easy",
	},
	{
		"question": "What time do you need to survive until to win a night in FNAF 1?",
		"answers": ["5:00 AM", "6:00 AM", "7:00 AM", "Midnight"],
		"correct": 1,
		"difficulty": "easy",
	},
	{
		"question": "What runs out if you use the doors and lights too much in FNAF 1?",
		"answers": ["Camera signal", "Oxygen", "Battery for flashlight", "Power"],
		"correct": 3,
		"difficulty": "easy",
	},
	{
		"question": "Which animatronic hides in Pirate Cove in FNAF 1?",
		"answers": ["Foxy", "Bonnie", "Freddy", "Chica"],
		"correct": 0,
		"difficulty": "easy",
	},
	{
		"question": "What tool do you mainly use to watch animatronics in FNAF 1?",
		"answers": ["Flashlight", "Radar", "Security cameras", "Motion sensor"],
		"correct": 2,
		"difficulty": "easy",
	},
	{
		"question": "Which animatronic is known for attacking from the left side in FNAF 1?",
		"answers": ["Chica", "Bonnie", "Freddy", "Foxy"],
		"correct": 1,
		"difficulty": "easy",
	},
	{
		"question": "Which animatronic is most associated with the right door in FNAF 1?",
		"answers": ["Bonnie", "Freddy", "Golden Freddy", "Chica"],
		"correct": 3,
		"difficulty": "easy",
	},
	{
		"question": "What usually happens if Foxy reaches your office while the door is open in FNAF 1?",
		"answers": ["Instant jumpscare", "Nothing", "You lose power", "Night ends"],
		"correct": 0,
		"difficulty": "easy",
	},
	{
		"question": "Where does the night guard stay during gameplay in FNAF 1?",
		"answers": ["Dining area", "Stage", "Security office", "Back room"],
		"correct": 2,
		"difficulty": "easy",
	},
	{
		"question": "Which animatronic plays the guitar on stage in FNAF 1?",
		"answers": ["Freddy", "Bonnie", "Chica", "Foxy"],
		"correct": 1,
		"difficulty": "easy",
	},
	{
		"question": "Which animatronic is usually seen with a cupcake in FNAF 1?",
		"answers": ["Bonnie", "Freddy", "Foxy", "Chica"],
		"correct": 3,
		"difficulty": "easy",
	},
	{
		"question": "What happens when your power hits 0% in FNAF 1?",
		"answers": [
			"Doors open and systems shut down",
			"The night instantly ends",
			"You gain unlimited flashlight",
			"Animatronics stop moving",
		],
		"correct": 0,
		"difficulty": "easy",
	},
	{
		"question": "Who is the caller that leaves messages for you in FNAF 1?",
		"answers": ["Phone Kid", "Manager", "Phone Guy", "Henry"],
		"correct": 2,
		"difficulty": "easy",
	},
	{
		"question": "Which room can’t be viewed on camera in FNAF 1 (you only hear audio)?",
		"answers": ["Restrooms", "Kitchen", "Show Stage", "Backstage"],
		"correct": 1,
		"difficulty": "easy",
	},
	{
		"question": "Which song is famously associated with Freddy when the power goes out in FNAF 1?",
		"answers": ["Happy Birthday", "Jingle Bells", "Pop Goes the Weasel", "Toreador March"],
		"correct": 3,
		"difficulty": "easy",
	},
	{
		"question": "What are the two main door controls in the FNAF 1 office?",
		"answers": ["Door and Light", "Door and Camera", "Light and Mask", "Mask and Shock"],
		"correct": 0,
		"difficulty": "easy",
	},
	{
		"question": "What is the name of the restaurant in the first game?",
		"answers": ["Circus Baby’s Pizza", "Fazbear’s Fright", "Freddy Fazbear’s Pizza", "Fredbear’s Family Diner"],
		"correct": 2,
		"difficulty": "easy",
	},
	{
		"question": "In FNAF 1, how many nights are there including Night 6 (but not Custom Night)?",
		"answers": ["4", "6", "5", "7"],
		"correct": 1,
		"difficulty": "easy",
	},

	# --- MEDIUM (19–38) ---
	{
		"question": "In FNAF 2, what item do you wear to fool most animatronics?",
		"answers": ["Spring Bonnie suit", "Fox mask", "Security helmet", "Freddy mask"],
		"correct": 3,
		"difficulty": "medium",
	},
	{
		"question": "In FNAF 2, what must you wind up to keep The Puppet away?",
		"answers": ["Music box", "Generator", "Camera signal", "Alarm clock"],
		"correct": 0,
		"difficulty": "medium",
	},
	{
		"question": "In FNAF 2, what tool is used repeatedly in the hallway to deter certain animatronics?",
		"answers": ["Door button", "Audio lure", "Flashlight", "Shock panel"],
		"correct": 2,
		"difficulty": "medium",
	},
	{
		"question": "What are the newer, shinier versions of the main cast in FNAF 2 called?",
		"answers": ["Glamrock animatronics", "Toy animatronics", "Phantoms", "Nightmares"],
		"correct": 1,
		"difficulty": "medium",
	},
	{
		"question": "Which character is infamous for disabling your flashlight in FNAF 2?",
		"answers": ["Mangle", "Withered Bonnie", "The Puppet", "Balloon Boy"],
		"correct": 3,
		"difficulty": "medium",
	},
	{
		"question": "What is the name of the main antagonist animatronic in FNAF 3?",
		"answers": ["Springtrap", "Ennard", "Nightmare", "Golden Freddy"],
		"correct": 0,
		"difficulty": "medium",
	},
	{
		"question": "What is the main tool you use to lure Springtrap in FNAF 3?",
		"answers": ["Flashlight", "Freddy mask", "Audio lure", "Shock panel"],
		"correct": 2,
		"difficulty": "medium",
	},
	{
		"question": "In FNAF 3, what system must you keep working to reduce hallucinations and breathing effects?",
		"answers": ["Power grid", "Ventilation", "Door locks", "Music box"],
		"correct": 1,
		"difficulty": "medium",
	},
	{
		"question": "What are the ghostly hallucination enemies in FNAF 3 called?",
		"answers": ["Toys", "Withereds", "Shadows", "Phantoms"],
		"correct": 3,
		"difficulty": "medium",
	},
	{
		"question": "Where does most of FNAF 4 take place?",
		"answers": ["A bedroom", "A pizzeria", "A basement lab", "A mall"],
		"correct": 0,
		"difficulty": "medium",
	},
	{
		"question": "In FNAF 4, what do you listen for at the doors to know an animatronic is there?",
		"answers": ["Laughter", "Footsteps only", "Breathing", "Phone calls"],
		"correct": 2,
		"difficulty": "medium",
	},
	{
		"question": "In FNAF 4, what do you use to scare away the small Freddles on the bed?",
		"answers": ["Music box", "Flashlight", "Mask", "Shock panel"],
		"correct": 1,
		"difficulty": "medium",
	},
	{
		"question": "What is the facility called in Sister Location?",
		"answers": ["Freddy Fazbear’s Mega Pizzaplex", "Fazbear’s Fright", "Fredbear’s Family Diner", "Circus Baby’s Entertainment and Rental"],
		"correct": 3,
		"difficulty": "medium",
	},
	{
		"question": "What is the name of the guiding AI voice in Sister Location?",
		"answers": ["HandUnit", "Phone Guy", "HelpBot", "Tape Girl"],
		"correct": 0,
		"difficulty": "medium",
	},
	{
		"question": "What is the name of the combined entity formed by multiple animatronics in Sister Location?",
		"answers": ["Springtrap", "Lefty", "Ennard", "Glitchtrap"],
		"correct": 2,
		"difficulty": "medium",
	},
	{
		"question": "What is the name of the room associated with the 'scooping' mechanism in Sister Location?",
		"answers": ["Party Room", "Scooping Room", "Safe Room", "Prize Corner"],
		"correct": 1,
		"difficulty": "medium",
	},
	{
		"question": "What is FNAF 6 commonly known as?",
		"answers": ["Fazbear’s Fright", "Help Wanted", "Security Breach", "Freddy Fazbear’s Pizzeria Simulator"],
		"correct": 3,
		"difficulty": "medium",
	},
	{
		"question": "What is the horror attraction in FNAF 3 called?",
		"answers": ["Fazbear’s Fright", "Freddy Fazbear’s Pizza", "Circus World", "Mega Pizzaplex"],
		"correct": 0,
		"difficulty": "medium",
	},
	{
		"question": "Who is 'Purple Guy' most commonly known as?",
		"answers": ["Henry Emily", "Michael Schmidt", "William Afton", "Jeremy Fitzgerald"],
		"correct": 2,
		"difficulty": "medium",
	},
	{
		"question": "In Ultimate Custom Night, what is the highest difficulty level you can set for an animatronic?",
		"answers": ["10", "20", "15", "25"],
		"correct": 1,
		"difficulty": "medium",
	},

	# --- HARD (39–50) ---
	{
		"question": "In FNAF 2, what is the name fans use for the minigame where the Puppet gives life to the children?",
		"answers": ["Happiest Day", "Take Cake to the Children", "Follow Me", "Give Gifts, Give Life"],
		"correct": 3,
		"difficulty": "hard",
	},
	{
		"question": "In FNAF 3, what is the well-known minigame/end sequence called that represents freeing the children?",
		"answers": ["Happiest Day", "Give Gifts, Give Life", "Save Them", "Midnight Motorist"],
		"correct": 0,
		"difficulty": "hard",
	},
	{
		"question": "Springtrap is associated with which spring-lock suit character?",
		"answers": ["Toy Bonnie", "Nightmare Bonnie", "Spring Bonnie", "Glamrock Bonnie"],
		"correct": 2,
		"difficulty": "hard",
	},
	{
		"question": "In Ultimate Custom Night, which character can randomly appear and add a new animatronic to the night?",
		"answers": ["Helpy", "Dee Dee", "Balloon Boy", "Tape Girl"],
		"correct": 1,
		"difficulty": "hard",
	},
	{
		"question": "The Puppet is also commonly known by what other name?",
		"answers": ["The Mimic", "The Plush", "The Endo", "The Marionette"],
		"correct": 3,
		"difficulty": "hard",
	},
	{
		"question": "What is the name of the minigame where you play as a character delivering cake outside a pizzeria?",
		"answers": ["Take Cake to the Children", "Follow Me", "Happiest Day", "Foxy Go Go Go"],
		"correct": 0,
		"difficulty": "hard",
	},
	{
		"question": "In later lore, who is the co-founder of the original pizzeria business alongside William Afton?",
		"answers": ["Jeremy Fitzgerald", "Michael Afton", "Henry Emily", "Fritz Smith"],
		"correct": 2,
		"difficulty": "hard",
	},
	{
		"question": "In FNAF 6, what is the name of Ennard’s later form after Circus Baby is no longer part of it?",
		"answers": ["Springtrap", "Molten Freddy", "Lefty", "Glamrock Freddy"],
		"correct": 1,
		"difficulty": "hard",
	},
	{
		"question": "In Security Breach, what is the main location called?",
		"answers": ["Fazbear’s Fright", "Circus Baby’s Rental", "Fredbear’s Family Diner", "Freddy Fazbear’s Mega Pizzaplex"],
		"correct": 3,
		"difficulty": "hard",
	},
	{
		"question": "In Security Breach, which character can Gregory hide inside for protection?",
		"answers": ["Glamrock Freddy", "Roxanne Wolf", "Montgomery Gator", "Chica"],
		"correct": 0,
		"difficulty": "hard",
	},
	{
		"question": "Which game is the VR entry in the series with many recreated minigames?",
		"answers": ["Five Nights at Freddy’s 4", "Sister Location", "Five Nights at Freddy’s: Help Wanted", "Pizzeria Simulator"],
		"correct": 2,
		"difficulty": "hard",
	},
	{
		"question": "Which animatronic is the main threat on the final standard night of FNAF 4 (Night 5)?",
		"answers": ["Nightmare", "Nightmare Fredbear", "Plushtrap", "Mangle"],
		"correct": 1,
		"difficulty": "hard",
	},
]

var allowed_strikes: int = 3
var current_wrong_answers = 0
var current_question: int = 0
var current_hour: int = 0
var current_correct_answers: int = 0
var difficulty = "easy"
var current_question_data: Dictionary = { }


func start_run() -> void:
	Engine.time_scale = 1
	reset_all_values()
	_randomize_allowed_strikes_count()
	randomize_questions_and_emit_current()


func reset_all_values() -> void:
	allowed_strikes = 1
	current_wrong_answers = 0
	current_correct_answers = 0
	current_question = 0
	current_hour = 0
	difficulty = "easy"


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


func randomize_questions_and_emit_current() -> void:
	randomize()
	question_array.shuffle()
	_emit_current()


func on_hour_changed(hour: int) -> void:
	current_hour = hour


func lose_game() -> void:
	game_lost.emit()


func _get_questions_by_difficulty() -> Array:
	return question_array.filter(
		func(element):
			return element["difficulty"] == determnie_game_difficulty_based_on_current_hour()
	)


func determine_camera_shake_amount() -> float:
	return clamp(0.25 + 0.15 * float(current_wrong_answers), 0.25, 0.7)


func player_answer(index: int) -> void:
	var correct: int = int(current_question_data.get("correct", -1))

	if index == correct:
		AudioManager.play("Correct")
		current_correct_answers += 1
		correctly_answered_changed.emit(current_correct_answers)

		if current_question >= question_array.size():
			game_won.emit()
			return

	else:
		AudioManager.play("Incorrect")
		current_wrong_answers += 1
		wrongly_answered_changed.emit(current_wrong_answers)
		camera_shake_amount.emit(determine_camera_shake_amount())

		if current_wrong_answers >= allowed_strikes:
			game_lost.emit()
			return

	current_question += 1
	_emit_current()


func determnie_game_difficulty_based_on_current_hour() -> String:
	if current_hour <= 2:
		difficulty = "easy"
	elif current_hour <= 4:
		difficulty = "medium"
	else:
		difficulty = "hard"

	return difficulty


func _emit_current() -> void:
	# Get filtered questions
	var filtered_questions = _get_questions_by_difficulty()

	# If we've gone through all questions of this difficulty, we might need to handle that
	# For now, let's just pick a random one from the filtered list
	if filtered_questions.size() > 0:
		var random_index = randi() % filtered_questions.size()
		var selected_question = filtered_questions[random_index]

		current_question_data = selected_question

		var question = str(selected_question.get("question", ""))
		var answer = selected_question.get("answers", [])

		question_changed.emit(question)
		answers_changed.emit(answer)
		determine_question_timer.emit()
		answered_question_count.emit(current_question)
		difficulty_changed.emit(difficulty)
		allowed_strikes_changed.emit(allowed_strikes)
	else:
		print("ERROR: No questions available for difficulty: ", difficulty)
