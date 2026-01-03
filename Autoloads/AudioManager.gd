extends Node

@export_group("Main")
@export var clips_path: NodePath

@export_group("Extras")
@export var click_audio: AudioStream

@onready var clips: Node = get_node_or_null(clips_path)
var active_music_stream: AudioStreamPlayer


func _ready() -> void:
	# 1) Must be instanced from a scene (autoload the .tscn), otherwise exports won't be set.
	if clips_path.is_empty():
		push_error("AudioManager: clips_path is empty. (Did you autoload the .tscn, not the .gd?)")
		return

	# 2) clips_path must point to an existing node.
	if clips == null:
		push_error("AudioManager: clips_path is invalid: %s" % str(clips_path))
		return

	# 3) Clips container should have AudioStreamPlayer children.
	var players := _list_players()
	if players.is_empty():
		push_warning(
			"AudioManager: '%s' has no AudioStreamPlayer children. Add players under Clips."
			% clips.name,
		)


func play(audio_name: String, from_position: float = 0.0, restart: bool = false) -> void:
	if restart and active_music_stream and active_music_stream.name == audio_name:
		return

	# 4) If setup failed, bail with a clear message.
	if clips == null:
		push_error(
			"AudioManager.play('%s'): clips is null (setup failed). Check clips_path/autoload scene."
			% audio_name,
		)
		return

	# 5) Audio name must match a child node name under Clips.
	var player := clips.get_node_or_null(audio_name) as AudioStreamPlayer
	if player == null:
		var available := _list_players()
		var available_text := "(none)" if available.is_empty() else ", ".join(available)
		push_warning(
			"AudioManager: Clip not found: '%s'. Available: %s"
			% [audio_name, available_text],
		)
		return

	active_music_stream = player
	active_music_stream.play(from_position)


func _list_players() -> Array[String]:
	var names: Array[String] = []
	for child in clips.get_children():
		var p := child as AudioStreamPlayer
		if p:
			names.append(p.name)
	return names
