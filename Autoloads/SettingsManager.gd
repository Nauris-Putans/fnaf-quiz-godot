extends Node

# Stores db volumes by bus name: "Master", "Music", "SFX"
var bus_volume_db: Dictionary = { }

# Fullscreen preference (session only)
var fullscreen: bool = false
var mute: bool = false


func _ready() -> void:
	# Initialize from current project defaults (AudioServer + DisplayServer)
	_cache_defaults()


func _cache_defaults() -> void:
	# Cache current bus volumes as defaults
	bus_volume_db.clear()
	for i in range(AudioServer.bus_count):
		var bus_name: StringName = AudioServer.get_bus_name(i)
		bus_volume_db[bus_name] = AudioServer.get_bus_volume_db(i)

	# Cache current window mode as default
	fullscreen = (DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN)
	var master_id := AudioServer.get_bus_index("Master")
	mute = AudioServer.is_bus_mute(master_id) if master_id != -1 else false


func set_bus_volume_db(bus_name: StringName, db: float) -> void:
	bus_volume_db[bus_name] = db
	_apply_bus(bus_name)


func get_bus_volume_db(bus_name: StringName, fallback_db: float = 0.0) -> float:
	if bus_volume_db.has(bus_name):
		return float(bus_volume_db[bus_name])

	# Fallback to AudioServer if not stored yet
	var id := AudioServer.get_bus_index(String(bus_name))
	return AudioServer.get_bus_volume_db(id) if id != -1 else fallback_db


func set_fullscreen(enabled: bool) -> void:
	fullscreen = enabled
	DisplayServer.window_set_mode(
		DisplayServer.WINDOW_MODE_FULLSCREEN if enabled else DisplayServer.WINDOW_MODE_WINDOWED,
	)


func set_mute(is_audio_muted: bool) -> void:
	mute = is_audio_muted
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), is_audio_muted)


func apply_all() -> void:
	# Apply all cached bus volumes
	for bus_name in bus_volume_db.keys():
		_apply_bus(bus_name)

	# Apply fullscreen
	set_fullscreen(fullscreen)
	set_mute(mute)


func _apply_bus(bus_name: StringName) -> void:
	var id := AudioServer.get_bus_index(String(bus_name))
	if id == -1:
		push_warning("SettingsManager: bus not found: %s" % String(bus_name))
		return
	AudioServer.set_bus_volume_db(id, float(bus_volume_db[bus_name]))
