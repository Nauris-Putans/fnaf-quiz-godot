extends Control

class_name Credits

signal back_requested

@export var back_scene_path: String = "res://Scenes/main_screen.tscn"
@export var use_signal_back := false
@export var show_background_static := true

@onready var screen_static: AnimatedSprite2D = %ScreenStatic


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

	if not show_background_static:
		screen_static.hide()
		screen_static.stop()
		screen_static.modulate.a = 0.0


func _on_back_pressed() -> void:
	if use_signal_back:
		back_requested.emit()
	else:
		SceneManager.swap_scenes(back_scene_path, get_tree().root, self, "fade_to_black")
