extends Control

@onready var question_label: Label = %QuestionLabel
@onready var answer_container: VBoxContainer = %AnswerContainer
@onready var debugger: Debugger = %Debugger
@onready var jumpscare: Jumpscare = %Jumpscare
@onready var clock: Clock = %Clock


func _ready():
	hide_all()

	debugger.win_button_pressed.connect(_on_game_won)
	debugger.lose_button_pressed.connect(transition_to_end_screen)
	debugger.random_question_button_pressed.connect(_on_question_randomize)
	clock.six_am_reached.connect(_on_game_won)
	clock.current_hour_changed.connect(GameManager.on_hour_changed)

	# Listen to GameManager updates
	GameManager.question_changed.connect(_on_question_changed)
	GameManager.answers_changed.connect(_on_answers_changed)

	# Listen for end conditions
	GameManager.game_won.connect(_on_game_won)
	GameManager.game_lost.connect(_on_game_lost)

	# Hook up answer buttons once
	_connect_answer_buttons_once()

	# Start a run when entering gameplay scene
	GameManager.start_run()


func hide_all() -> void:
	hide()
	jumpscare.hide()
	debugger.hide()


# Toggle debbuger
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("debug") and OS.is_debug_build():
		debugger.visible = !debugger.visible


func _connect_answer_buttons_once() -> void:
	var index: int = 0

	for child in answer_container.get_children():
		var button: Button = child as Button

		if button:
			if not button.pressed.is_connected(_on_answer_pressed.bind(index)):
				button.pressed.connect(_on_answer_pressed.bind(index))
		index += 1


func _on_question_changed(text: String) -> void:
	question_label.text = text


func _on_answers_changed(answers: Array) -> void:
	for index in range(min(answer_container.get_child_count(), answers.size())):
		var button: Button = answer_container.get_child(index) as Button

		if button:
			button.text = str(answers[index])


func _on_question_randomize() -> void:
	print("_on_question_randomize")
	GameManager.randomize_questions_and_emit_current()


func _on_answer_pressed(index: int) -> void:
	GameManager.player_answer(index)


func _on_game_won() -> void:
	transition_to_end_screen(true)


func _on_game_lost() -> void:
	jumpscare.play_animation()


func transition_to_end_screen(won: bool = false) -> void:
	# Store result so end screen can read it
	GameManager.set_meta("last_result", won)

	SceneManager.swap_scenes(
		"res://Scenes/end_screen.tscn",
		get_tree().root,
		get_tree().current_scene,
		"fade_to_black",
	)
