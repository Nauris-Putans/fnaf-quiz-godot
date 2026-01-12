extends Control

@onready var question_label: Label = %QuestionLabel
@onready var answer_container: VBoxContainer = %AnswerContainer
@onready var debugger: Debugger = %Debugger
@onready var jumpscare: Jumpscare = %Jumpscare
@onready var clock: Clock = %Clock
@onready var shake_camera: ShakeCamera = %ShakeCamera
@onready var screen_static: AnimatedSprite2D = %ScreenStatic

var allowed_strikes: int = 3
var _answers_locked := false


func _ready():
	hide_all()

	debugger.win_button_pressed.connect(_on_game_won)
	debugger.lose_button_pressed.connect(transition_to_end_screen)
	debugger.random_question_button_pressed.connect(_on_question_randomize)
	clock.six_am_reached.connect(_on_game_won)
	clock.current_hour_changed.connect(GameManager.on_hour_changed)

	GameManager.camera_shake_amount.connect(perform_camera_shake)
	GameManager.wrongly_answered_changed.connect(update_screen_static)
	GameManager.allowed_strikes_changed.connect(set_allowed_strikes)

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
	reset_screen_static()


func reset_screen_static() -> void:
	screen_static.hide()
	screen_static.modulate.a = 0


func update_screen_static(count: int) -> void:
	if count == 0:
		# No wrong answers - hide static
		screen_static.hide()
		screen_static.modulate.a = 0
		return

	# Disable answering while static is shown
	_set_answers_enabled(false)

	# Show static briefly with intensity
	screen_static.show()

	# Formula: fewer allowed_strikes = more intense static
	var base_intensity = 1.0 / allowed_strikes
	var alpha = count * base_intensity
	screen_static.modulate.a = min(alpha, 0.8)

	# Fade out after 1 seconds
	await get_tree().create_timer(1).timeout

	# Fade out animation
	var tween = create_tween()
	tween.tween_property(screen_static, "modulate:a", 0.0, 0.5)
	await tween.finished

	screen_static.hide()

	# Only ask next question if game isn't over
	if not GameManager.run_over:
		GameManager.next_question()


func set_allowed_strikes(strikes: int) -> void:
	allowed_strikes = strikes


func _set_answers_enabled(enabled: bool) -> void:
	_answers_locked = not enabled
	for child in answer_container.get_children():
		var button := child as Button
		if button:
			button.disabled = not enabled
			button.mouse_filter = Control.MOUSE_FILTER_STOP


# Toggle debbuger
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("debug") and OS.is_debug_build():
		debugger.visible = !debugger.visible


func _connect_answer_buttons_once() -> void:
	var index: int = 0

	for child in answer_container.get_children():
		var button: Button = child as Button
		if button:
			button.action_mode = BaseButton.ACTION_MODE_BUTTON_RELEASE # IMPORTANT
			button.toggle_mode = false
			button.focus_mode = Control.FOCUS_NONE

			if not button.pressed.is_connected(_on_answer_pressed.bind(index)):
				button.pressed.connect(_on_answer_pressed.bind(index))

		index += 1


func _on_question_changed(text: String) -> void:
	if question_label.has_method("set_fit_text"):
		question_label.call("set_fit_text", text)
	else:
		question_label.text = text


func _on_answers_changed(answers: Array) -> void:
	# Update texts
	for i in range(answer_container.get_child_count()):
		var button := answer_container.get_child(i) as Button
		if not button:
			continue

		if i < answers.size():
			button.text = str(answers[i])
			button.visible = true
		else:
			button.text = ""
			button.visible = false # hide extra buttons if any

	# Re-enable AFTER this event finishes (prevents “stuck disabled”)
	call_deferred("_set_answers_enabled", true)


func _on_question_randomize() -> void:
	GameManager.randomize_questions_and_emit_current()


func _on_answer_pressed(index: int) -> void:
	if _answers_locked:
		return

	_answers_locked = true
	for child in answer_container.get_children():
		var b := child as Button
		if b:
			b.set_deferred("disabled", true)

	get_viewport().gui_release_focus()

	clock.pause_question_timer()
	var seconds_remaining := clock.get_question_seconds_left()
	GameManager.player_answer(index, seconds_remaining)


func _on_game_won() -> void:
	transition_to_end_screen(true)


func _on_game_lost() -> void:
	_set_answers_enabled(false)
	perform_camera_shake(0.7)
	update_screen_static(3)
	jumpscare.play_animation()


func perform_camera_shake(amount: float) -> void:
	shake_camera.add_trauma(amount)


func transition_to_end_screen(won: bool = false) -> void:
	# Store result so end screen can read it
	GameManager.set_meta("last_result", won)

	SceneManager.swap_scenes(
		"res://Scenes/end_screen.tscn",
		get_tree().root,
		get_tree().current_scene,
		"fade_to_black",
	)
