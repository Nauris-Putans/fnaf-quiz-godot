extends Control

class_name EndScreen

@onready var title_label: Label = %Title
@onready var score: Label = %Score
@onready var high_score_label: Label = %HighScore
@onready var breakdown: Label = %Breakdown

@onready var restart_button: Button = %Restart
@onready var main_menu_button: Button = %MainMenu


func _ready() -> void:
	show()

	var won: bool = bool(GameManager.get_meta("last_result", false))

	if won:
		AudioManager.play("Win")
	else:
		AudioManager.play("Lose")

	title_label.text = "You survived!" if won else "Game over"

	if bool(GameManager.get_meta("super_fan", false)):
		title_label.text = "Super Fan!"
	restart_button.visible = not won

	_set_end_scores()

	connect_once(main_menu_button.pressed, _on_main_menu_pressed)
	connect_once(restart_button.pressed, _on_restart_pressed)


func _set_end_scores() -> void:
	var best_score := int(GameManager.get_meta("high_score", GameManager.high_score))
	var time_bonus := int(GameManager.get_meta("last_time_bonus", 0))
	var perfect_bonus := int(GameManager.get_meta("last_perfect_bonus", 0))
	var total := int(GameManager.get_meta("last_score", 0))
	var correct := int(GameManager.get_meta("last_correct_answered", 0))

	score.text = "Score: %d" % total
	high_score_label.text = "High score: %d" % best_score

	var lines: Array[String] = []
	lines.append("Correct answers: %d (+%d)" % [correct, correct * 100])
	lines.append("Time bonus: +%d" % time_bonus)

	if perfect_bonus > 0:
		lines.append("Perfect run: +%d" % perfect_bonus)

	var super_fan := bool(GameManager.get_meta("super_fan", false))
	if super_fan:
		lines.append("")
		lines.append("YOU ARE A SUPER FNAF FAN!")
		lines.append("You answered every question. Great job!")

	breakdown.text = "\n".join(lines)


func connect_once(sig: Signal, handler: Callable) -> void:
	if not sig.is_connected(handler):
		sig.connect(handler)


func _on_main_menu_pressed() -> void:
	SceneManager.swap_scenes(
		"res://Scenes/main_screen.tscn",
		get_tree().root,
		get_tree().current_scene,
		"fade_to_black",
	)


func _on_restart_pressed() -> void:
	SceneManager.swap_scenes(
		"res://Scenes/main.tscn",
		get_tree().root,
		get_tree().current_scene,
		"fade_to_black",
	)
