extends Control

@export var intro_zoom := 1.46
@export var auto_advance_seconds := 25.0
@export var next_scene_path := "res://Scenes/main.tscn"

@onready var content: Control = %Content

var _skipping := false


func _ready() -> void:
	AudioManager.stop_music()
	AudioManager.play("Game")

	# Scale around center
	content.anchor_left = 0
	content.anchor_top = 0
	content.anchor_right = 1
	content.anchor_bottom = 1
	content.position += Vector2(-40, -110)

	content.pivot_offset = get_viewport_rect().size * 0.5
	content.scale = Vector2.ONE * intro_zoom

	# Start auto-advance timer
	_auto_advance()


func _auto_advance() -> void:
	await get_tree().create_timer(auto_advance_seconds).timeout
	_go_next()


# Skip game intro by pressing any input
func _input(event: InputEvent) -> void:
	if _skipping:
		return

	var pressed: bool = (
		(event is InputEventKey and event.pressed) or
		(event is InputEventMouseButton and event.pressed) or
		(event is InputEventScreenTouch and event.pressed)
	)

	if not pressed:
		return

	_go_next()


func _go_next() -> void:
	if _skipping:
		return

	_skipping = true

	SceneManager.swap_scenes(
		next_scene_path,
		get_tree().root,
		get_tree().current_scene,
		"fade_to_black",
	)
