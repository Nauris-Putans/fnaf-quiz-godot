extends Camera2D

class_name ShakeCamera

@export_group("World")
@export var decay: float = 0.8
@export var max_offset: Vector2 = Vector2(30, 20)
@export var max_roll: float = 0.5
@export var follow_node: Node2D

var trauma: float = 0.0
var trauma_power: int = 2

@export_group("UI")
@export var ui_layer: CanvasLayer
@export var ui_max_offset: Vector2 = Vector2(4, 3)
@export var ui_max_roll: float = 0.05

var _ui_base_offset: Vector2 = Vector2.ZERO
var _ui_base_rotation: float = 0.0


func _ready():
	randomize()

	if ui_layer:
		_ui_base_offset = ui_layer.offset
		_ui_base_rotation = ui_layer.rotation


func _process(delta):
	if follow_node:
		global_position = follow_node.global_position

	if trauma > 0.0:
		trauma = max(trauma - decay * delta, 0.0)
		shake()
	else:
		offset = Vector2.ZERO
		rotation = 0.0
		if ui_layer:
			ui_layer.offset = _ui_base_offset
			ui_layer.rotation = _ui_base_rotation


func add_trauma(amount: float) -> void:
	trauma = min(trauma + amount, 1.0)


func shake() -> void:
	var amount := pow(trauma, trauma_power)

	# World (camera)
	rotation = max_roll * amount * randf_range(-1.0, 1.0)
	offset = Vector2(
		max_offset.x * amount * randf_range(-1.0, 1.0),
		max_offset.y * amount * randf_range(-1.0, 1.0),
	)

	# UI (screen-space)
	if ui_layer:
		ui_layer.rotation = _ui_base_rotation + ui_max_roll * amount * randf_range(-1.0, 1.0)
		ui_layer.offset = _ui_base_offset + Vector2(
			ui_max_offset.x * amount * randf_range(-1.0, 1.0),
			ui_max_offset.y * amount * randf_range(-1.0, 1.0),
		)
