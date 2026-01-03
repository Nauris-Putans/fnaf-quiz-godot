extends Control

class_name MainScreen

func _ready():
	AudioManager.play("Main", 0, true)


func _on_start_pressed() -> void:
	SceneManager.swap_scenes("res://Scenes/main.tscn", get_tree().root, self, "fade_to_black")


func _on_settings_pressed() -> void:
	SceneManager.swap_scenes("res://Scenes/settings.tscn", get_tree().root, self, "fade_to_black")


func _on_credits_pressed() -> void:
	SceneManager.swap_scenes("res://Scenes/credits.tscn", get_tree().root, self, "fade_to_black")


func _on_exit_pressed() -> void:
	get_tree().quit()
