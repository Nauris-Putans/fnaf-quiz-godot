extends CheckButton

class_name MuteControl

@onready var mute: CheckButton = %Mute

var is_muted: bool = false


func _ready() -> void:
	mute.set_pressed_no_signal(SettingsManager.mute)


func _on_toggled(is_audio_muted: bool) -> void:
	SettingsManager.set_mute(is_audio_muted)
