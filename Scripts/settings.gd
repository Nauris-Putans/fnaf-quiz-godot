extends Control

func _on_back_pressed() -> void:
	SceneManager.swap_scenes("res://Scenes/main_screen.tscn",get_tree().root,self,"fade_to_black")
