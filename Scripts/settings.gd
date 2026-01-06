extends Control

class_name Settings

signal back_requested

@export var back_scene_path: String = "res://Scenes/main_screen.tscn"
@export var use_signal_back := false


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS


func _on_back_pressed() -> void:
	if use_signal_back:
		back_requested.emit()
	else:
		SceneManager.swap_scenes(back_scene_path, get_tree().root, self, "fade_to_black")
