extends Node

@onready var question_label: Label = %QuestionLabel
@onready var answer_container: VBoxContainer = %AnswerContainer
@onready var game_over_screen: ColorRect = %GameOver
@onready var win_screen: ColorRect = %Win
@onready var debugger: Control = %Debugger
@onready var clock: Control = %Clock

var current_question: int = 0
var questionArray: Array = [
	{
		"question": "Who is the main animatronic mascot of Freddy Fazbear’s Pizza?",
		"answers": ["Freddy Fazbear", "Bonnie", "Chica", "Foxy"],
		"correct": 0
	},
	{
		"question": "What time do you need to survive until to win a night in FNAF 1?",
		"answers": ["5:00 AM", "6:00 AM", "7:00 AM", "Midnight"],
		"correct": 1
	},
	{
		"question": "What runs out if you use the doors and lights too much?",
		"answers": ["Camera signal", "Oxygen", "Power", "Battery for flashlight"],
		"correct": 2
	},
	{
		"question": "Which animatronic hides in Pirate Cove?",
		"answers": ["Bonnie", "Freddy", "Chica", "Foxy"],
		"correct": 3
	},
	{
		"question": "What tool do you mainly use to watch animatronics?",
		"answers": ["Flashlight", "Security cameras", "Radar", "Motion sensor"],
		"correct": 1
	},
	{
		"question": "Which animatronic is known for banging on the left door?",
		"answers": ["Chica", "Bonnie", "Freddy", "Foxy"],
		"correct": 1
	},
	{
		"question": "Which animatronic uses the right door?",
		"answers": ["Bonnie", "Freddy", "Chica", "Golden Freddy"],
		"correct": 2
	},
	{
		"question": "What happens if Foxy reaches your office?",
		"answers": ["Nothing", "You lose power", "Instant jumpscare", "Night ends"],
		"correct": 2
	},
	{
		"question": "How many nights are in the main game (without custom night)?",
		"answers": ["4", "5", "6", "7"],
		"correct": 2
	},
	{
		"question": "Where does the night guard sit during the game?",
		"answers": ["Dining area", "Stage", "Security office", "Back room"],
		"correct": 2
	}
]


func _ready() -> void:
	Engine.time_scale = 1
	game_over_screen.hide()
	win_screen.hide()
	showQuestion()
	showAnswers()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("debug") and OS.is_debug_build():
		debugger.visible = !debugger.visible

func randomizeQuestions() -> void:
	randomize()
	questionArray.shuffle()

func showQuestion():
	randomizeQuestions()
	question_label.text = questionArray[current_question].get("question")
	
func showAnswers():
	var index: int = 0
	for button in answer_container.get_children():
		button.text = questionArray[current_question].get("answers")[index]
		if (!button.is_connected("pressed", _on_button_pressed)):
			button.pressed.connect(_on_button_pressed.bind(index))
		
		index += 1

func _on_button_pressed(index : int) -> void:
	if index == questionArray[current_question].get("correct", -1):
		current_question += 1

		if current_question >= questionArray.size():
			on_you_survived()
			return
		
		showQuestion()
		showAnswers()
	else:
		on_game_over()

func on_game_over():
	game_over_screen.show()
	Engine.time_scale = 0
	
func on_you_survived():
	win_screen.show()
	Engine.time_scale = 0

func _on_button_restart_pressed() -> void:
	Engine.time_scale = 1
	get_tree().reload_current_scene()

func _on_clock_six_am_reached() -> void:
	on_you_survived()

func _on_debugger_win_button_pressed() -> void:
	on_you_survived()

func _on_debugger_random_question_button_pressed() -> void:
	pass # Replace with function body.

func _on_debugger_lose_button_pressed() -> void:
	on_game_over()

func _on_debugger_jumpscare_button_pressed() -> void:
	pass # Replace with function body.
