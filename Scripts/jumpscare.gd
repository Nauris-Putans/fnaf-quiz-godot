extends Control

class_name Jumpscare

@onready var freddy: AnimatedSprite2D = %Freddy
@onready var debugger: Debugger = %Debugger


func _ready():
	debugger.jumpscare_on_button_pressed.connect(play_animation)
	debugger.jumpscare_off_button_pressed.connect(stop_animation)


func play_animation() -> void:
	Engine.time_scale = 1
	show()
	freddy.stop()
	freddy.frame = 0
	freddy.play("jumpscare")


func stop_animation() -> void:
	Engine.time_scale = 0
	hide()
	freddy.stop()


func _on_freddy_animation_finished() -> void:
	print("_on_freddy_animation_finished")
	GameManager.set_meta("last_result", false)

	SceneManager.swap_scenes(
		"res://Scenes/end_screen.tscn",
		get_tree().root,
		get_tree().current_scene,
		"fade_to_black",
	)
