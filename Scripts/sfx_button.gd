extends Button

class_name SfxButton

@export var hover_sfx := "Hover"
@export var click_sfx := "Click"


func _ready() -> void:
	mouse_entered.connect(_play_hover)
	focus_entered.connect(_play_hover) # keyboard/gamepad
	pressed.connect(_play_click)


func _play_hover() -> void:
	if hover_sfx != "":
		AudioManager.play(hover_sfx)


func _play_click() -> void:
	if click_sfx != "":
		AudioManager.play(click_sfx)
