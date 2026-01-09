extends Control

class_name PauseMenu

@export var settings_scene: PackedScene = preload("res://Scenes/settings.tscn")
@export var credits_scene: PackedScene = preload("res://Scenes/credits.tscn")

@onready var blur: AnimationPlayer = %Blur
@onready var panel: PanelContainer = $PanelContainer
@onready var clock: Clock = %Clock

var paused: bool = false
var settings_ui: Settings = null
var credits_ui: Credits = null


func _ready() -> void:
	hide()
	blur.play("RESET")


# Toggle pause from here so it still works while the tree is paused
func _unhandled_input(event: InputEvent) -> void:
	if not (event is InputEventKey):
		return
	if not event.is_action_pressed("pause") or event.echo:
		return

	# If an overlay is open, close it instead of toggling pause
	if settings_ui:
		_on_settings_back()
		get_viewport().set_input_as_handled()
		return

	if credits_ui:
		_on_credits_back()
		get_viewport().set_input_as_handled()
		return

	# Otherwise toggle pause menu normally
	toggle_pause()
	get_viewport().set_input_as_handled()


func _overlay_open() -> bool:
	return settings_ui != null or credits_ui != null


func toggle_pause() -> void:
	if settings_ui or credits_ui:
		return

	paused = !paused
	get_tree().paused = paused

	if paused:
		clock.clock_status()
		show()
		blur.play("blur")
	else:
		clock.clock_status()
		blur.play_backwards("blur")
		hide()


func _on_resume_pressed() -> void:
	toggle_pause()


func _on_settings_pressed() -> void:
	# open settings as overlay (don’t swap scenes)
	if settings_ui != null:
		return

	panel.hide()

	settings_ui = settings_scene.instantiate() as Settings
	settings_ui.use_signal_back = true
	settings_ui.show_background_static = false
	settings_ui.back_requested.connect(_on_settings_back)

	# IMPORTANT:
	settings_ui.process_mode = Node.PROCESS_MODE_ALWAYS
	settings_ui.z_index = 4050

	# Add it to the same PauseLayer so it sits above everything
	get_parent().add_child(settings_ui)


func _on_settings_back() -> void:
	if settings_ui:
		settings_ui.queue_free()
		settings_ui = null
	panel.show()


func _on_credits_back() -> void:
	if credits_ui:
		credits_ui.queue_free()
		credits_ui = null

	panel.show()


func _on_credits_pressed() -> void:
	# open credits as overlay (don’t swap scenes)
	if credits_ui != null:
		return

	panel.hide()

	credits_ui = credits_scene.instantiate() as Credits
	credits_ui.use_signal_back = true
	credits_ui.show_background_static = false
	credits_ui.back_requested.connect(_on_credits_back)

	credits_ui.process_mode = Node.PROCESS_MODE_ALWAYS
	credits_ui.z_index = 4050

	# Add it to the same PauseLayer so it sits above everything
	get_parent().add_child(credits_ui)


func _on_quit_game_pressed() -> void:
	get_tree().quit()


func _on_exit_to_main_menu_pressed() -> void:
	# unpause before swapping scene, avoids carrying pause state
	get_tree().paused = false
	paused = false
	SceneManager.swap_scenes(
		"res://Scenes/main_screen.tscn",
		get_tree().root,
		self,
		"fade_to_black",
	)
