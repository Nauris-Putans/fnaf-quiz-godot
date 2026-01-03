extends HSlider

class_name AudioControl

@export var audio_bus_name: String

var audio_bus_id: int


func _ready():
	audio_bus_id = AudioServer.get_bus_index(audio_bus_name)


func _on_value_changed(audio_value: float) -> void:
	var db = linear_to_db(audio_value)
	AudioServer.set_bus_volume_db(audio_bus_id, db)
