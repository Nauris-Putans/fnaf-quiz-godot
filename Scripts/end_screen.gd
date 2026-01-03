extends Control

class_name EndScreen

@onready var lost: Control = %Lost
@onready var win: Control = %Win
@onready var main_menu_button: Button = %MainMenu
@onready var restart_button: Button = %Restart


func _ready():
	hide_all()

	var won: bool = bool(GameManager.get_meta("last_result", false))
	if won:
		show_win_screen()
	else:
		show_lost_screen()

	connect_once(main_menu_button.pressed, _on_main_menu_pressed)
	connect_once(restart_button.pressed, _on_restart_pressed)


func connect_once(sig: Signal, handler: Callable) -> void:
	if not sig.is_connected(handler):
		sig.connect(handler)


func hide_all() -> void:
	hide()
	win.hide()
	lost.hide()


func show_win_screen() -> void:
	hide_all()
	show()
	win.show()


func show_lost_screen() -> void:
	hide_all()
	show()
	lost.show()


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
