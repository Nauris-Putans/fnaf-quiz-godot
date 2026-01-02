extends Control
class_name Jumpscare

@onready var freddy: AnimatedSprite2D = %Freddy

func play_animation() -> void:
	Engine.time_scale = 1
	show()
	freddy.stop()
	freddy.frame = 0
	freddy.play("jumpscare")

func _on_freddy_animation_finished() -> void:
	Engine.time_scale = 0
