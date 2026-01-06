extends CheckButton

func _on_toggled(toggled_on: bool) -> void:
	AudioManager.play("Click")
	
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
