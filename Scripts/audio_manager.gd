extends HSlider

class_name AudioControl

@export var audio_bus_name: StringName = &"Music"
var audio_bus_id: int = -1


func _ready() -> void:
	audio_bus_id = AudioServer.get_bus_index(String(audio_bus_name))
	if audio_bus_id == -1:
		push_warning("AudioControl: bus not found: %s" % String(audio_bus_name))
		return

	# Restore slider position from saved db value (convert db -> linear 0..1)
	var db := SettingsManager.get_bus_volume_db(audio_bus_name)
	set_value_no_signal(db_to_linear(db))


func _on_value_changed(audio_value: float) -> void:
	var db := linear_to_db(audio_value)
	SettingsManager.set_bus_volume_db(audio_bus_name, db)
