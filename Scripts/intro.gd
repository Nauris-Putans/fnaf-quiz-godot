extends Control

@onready var line_label: Label = %LineLabel
@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var godot_icon: TextureRect = %GodotIcon

@export var godot_icon_texture: Texture2D
@export var base_font_size := 48
@export var small_font_size := 28

@export var steps := [
	{ "text": "Made by PapaSmurfDev" },
	{ "icon": "godot" },
	{
		"text": "This is an unofficial, non-commercial fan project inspired by Five Nights at Freddy’s.\nAll characters and references belong to their respective owners.",
		"size": "small",
		"fade_in": 0.7,
		"hold": 7.0,
		"fade_out": 0.7,
	},
]

@export var fade_in := 0.35
@export var hold := 2.0
@export var fade_out := 0.35
@export var gap := 0.15

var _skipping := false


func _ready():
	print("icon export=", godot_icon_texture, " icon node texture=", godot_icon.texture)

	line_label.modulate.a = 0.0
	godot_icon.modulate.a = 0.0
	godot_icon.hide()

	if godot_icon_texture:
		godot_icon.texture = godot_icon_texture

	_run_sequence()


func _run_sequence() -> void:
	for i in range(steps.size()):
		var step: Dictionary = steps[i]
		_apply_step(step)

		var fade_in_inside_inspector: float = float(step.get("fade_in", fade_in))
		var hold_inside_inspector: float = float(step.get("hold", hold))
		var fade_out_inside_insepctor: float = float(step.get("fade_out", fade_out))
		var gap_inside_insepctor: float = float(step.get("gap", gap))

		await _fade_alpha(1.0, fade_in_inside_inspector)
		await get_tree().create_timer(hold_inside_inspector).timeout
		await _fade_alpha(0.0, fade_out_inside_insepctor)

		# Prepare next step immediately (prevents “empty” moment)
		if i < steps.size() - 1:
			_apply_step(steps[i + 1])

		if gap_inside_insepctor > 0.0:
			await get_tree().create_timer(gap_inside_insepctor).timeout

	SceneManager.swap_scenes(
		"res://Scenes/main_screen.tscn",
		get_tree().root,
		self,
		"fade_to_black",
	)


func _apply_step(step: Dictionary) -> void:
	var text := str(step.get("text", ""))
	var icon_key := str(step.get("icon", ""))

	var has_icon_texture := godot_icon.texture != null
	var show_icon := icon_key == "godot" and has_icon_texture
	var show_text := text != ""

	# Content
	line_label.text = text

	# Size
	var size_key := str(step.get("size", "base"))
	line_label.add_theme_font_size_override(
		"font_size",
		small_font_size if size_key == "small" else base_font_size,
	)

	# Visibility
	line_label.visible = show_text
	godot_icon.visible = show_icon

	# Start each step fully transparent (so fade-in is consistent)
	line_label.modulate.a = 0.0
	godot_icon.modulate.a = 0.0


func _fade_alpha(alpha: float, duration: float) -> void:
	if duration <= 0.0:
		if line_label.visible:
			line_label.modulate.a = alpha
		if godot_icon.visible:
			godot_icon.modulate.a = alpha
		return

	var t := create_tween()
	t.set_parallel(true) # IMPORTANT: parallel tweeners

	if line_label.visible:
		t.tween_property(line_label, "modulate:a", alpha, duration)
	if godot_icon.visible:
		t.tween_property(godot_icon, "modulate:a", alpha, duration)

	await t.finished


# Skip intro by pressing any input
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

	_skipping = true
	SceneManager.swap_scenes(
		"res://Scenes/main_screen.tscn",
		get_tree().root,
		self,
		"fade_to_black",
	)
