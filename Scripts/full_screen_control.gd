extends CheckButton

class_name FullScreenControl

func _ready() -> void:
	set_pressed_no_signal(SettingsManager.fullscreen)


func _on_toggled(toggled_on: bool) -> void:
	AudioManager.play("Click")
	SettingsManager.set_fullscreen(toggled_on)
