class_name Debugger extends Control

signal win_button_pressed
signal lose_button_pressed
signal time_passed_buttton_pressed
signal jumpscare_button_pressed
signal random_question_button_pressed

@onready var fps_label: Label = %Fps
@onready var clock_label: Label = %CurrentHour
@onready var seconds_between_hour_label: Label = %SecondsBetweenHour
@onready var win: Button = %Win
@onready var lose: Button = %Lose
@onready var time_passed: Button = %TimePassed
@onready var jumpscare: Button = %Jumpscare
@onready var random_question: Button = %RandomQuestion

func _process(_delta: float) -> void:
	fps_label.text = str("FPS: ", Engine.get_frames_per_second())
	
func on_hour_changed(text: String) -> void:
	clock_label.text = "Clock: %s" % text

func on_seconds_left_changed(seconds_left: int) -> void:
	seconds_between_hour_label.text = "Next hour in: %d" % seconds_left

func _on_win_pressed() -> void:
	win_button_pressed.emit()

func _on_lose_pressed() -> void:
	lose_button_pressed.emit()

func _on_time_passed_pressed() -> void:
	time_passed_buttton_pressed.emit()

func _on_jumpscare_pressed() -> void:
	jumpscare_button_pressed.emit()

func _on_random_question_pressed() -> void:
	random_question_button_pressed.emit()
