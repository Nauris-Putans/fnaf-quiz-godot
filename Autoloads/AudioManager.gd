extends Node

@export_group("Setup")
## Path to the node that contains all your AudioStreamPlayer children (e.g. "Clips").
@export var clips_path: NodePath

@export_group("Conventions")
## Any AudioStreamPlayer on this bus is treated as "music".
@export var music_bus_name: StringName = &"Music"

@onready var clips: Node = get_node_or_null(clips_path)

## Cache: clip name -> AudioStreamPlayer
var _players: Dictionary = { }

## Track currently playing music so we can avoid restarting it.
var _active_music: AudioStreamPlayer = null
var _active_music_name: StringName = &""


func _ready() -> void:
	# 1) This manager should be autoloaded as a *scene* (AudioManager.tscn),
	#    so exports (clips_path) are set and the Clips node exists.
	if clips_path.is_empty():
		push_error("AudioManager: clips_path is empty. Autoload the .tscn, not the .gd.")
		return

	# 2) clips_path must point to an existing node.
	if clips == null:
		push_error("AudioManager: clips_path is invalid: %s" % str(clips_path))
		return

	_cache_players()

	if _players.is_empty():
		push_warning("AudioManager: No AudioStreamPlayer children found under '%s'." % clips.name)


## Plays a clip by node name under Clips.
##
## - For SFX: just plays it.
## - For Music (bus == music_bus_name): optionally prevents restarting the same track.
##
## keep_if_playing:
##   - Only matters for music.
##   - If true and the same music is already playing, it will NOT restart.
func play(audio_name: StringName, from_position: float = 0.0, keep_if_playing: bool = false) -> void:
	var player := _get_player(audio_name)
	if player == null:
		return

	# Music handling (prevents restarts + stops previous music if switching tracks)
	if player.bus == music_bus_name:
		_play_music(player, audio_name, from_position, keep_if_playing)
		return

	# SFX handling (does NOT touch active music tracking)
	player.play(from_position)


func _play_music(player: AudioStreamPlayer, audio_name: StringName, from_position: float, keep_if_playing: bool) -> void:
	# If the same music is already playing and we want to keep it, do nothing.
	if keep_if_playing and _active_music == player and player.playing:
		return

	# If switching music tracks, stop the previous one to avoid overlap.
	if _active_music != null and _active_music != player:
		_active_music.stop()

	_active_music = player
	_active_music_name = audio_name
	_active_music.play(from_position)


## Optional helper: stop whatever music is currently tracked.
func stop_music() -> void:
	if _active_music != null:
		_active_music.stop()


## Optional helper: check if any music is playing (or a specific track).
func is_music_playing(track_name: StringName = &"") -> bool:
	if _active_music == null or not _active_music.playing:
		return false
	return track_name == &"" or _active_music_name == track_name


func _cache_players() -> void:
	_players.clear()
	for child in clips.get_children():
		var p := child as AudioStreamPlayer
		if p != null:
			_players[p.name] = p


func _get_player(audio_name: StringName) -> AudioStreamPlayer:
	# Fast path: cached lookup
	if _players.has(audio_name):
		return _players[audio_name]

	# Slow path: node lookup (and a helpful warning)
	var player := clips.get_node_or_null(String(audio_name)) as AudioStreamPlayer
	if player == null:
		var available := _players.keys()
		var available_text := "(none)" if available.is_empty() else ", ".join(available)
		push_warning("AudioManager: Clip not found: '%s'. Available: %s" % [audio_name, available_text])
		return null

	# If it exists but wasn't cached (e.g. added at runtime), cache it.
	_players[audio_name] = player
	return player
