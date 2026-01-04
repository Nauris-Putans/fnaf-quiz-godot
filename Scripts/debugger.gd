extends Control

class_name Debugger

signal win_button_pressed
signal lose_button_pressed
signal time_passed_buttton_pressed
signal random_question_button_pressed
signal jumpscare_on_button_pressed
signal jumpscare_off_button_pressed
signal stop_time_button_pressed

@onready var fps_label: Label = %Fps
@onready var clock_label: Label = %CurrentHour
@onready var seconds_between_hour_label: Label = %SecondsBetweenHour
@onready var answered_questions: Label = %AnsweredQuestions
@onready var time_button: Button = %Time
@onready var difficulty_label: Label = %Difficulty
@onready var allowed_strikes_label: Label = %AllowedStrikes
@onready var wrongly_answered_label: Label = %WronglyAnswered
@onready var correctly_answered_label: Label = %CorrectlyAnswered

var is_time_stopped: bool = false


func _ready():
	GameManager.answered_question_count.connect(on_question_answer_changed)
	GameManager.difficulty_changed.connect(on_dificultly_changed)
	GameManager.allowed_strikes_changed.connect(on_allowed_strikes_changed)
	GameManager.correctly_answered_changed.connect(on_correctly_answered_changed)
	GameManager.wrongly_answered_changed.connect(on_wrongly_answered_changed)


func _process(_delta: float) -> void:
	fps_label.text = str("FPS = %s" % Engine.get_frames_per_second())


func on_hour_changed(text: String) -> void:
	clock_label.text = "Clock = %s" % text


func on_seconds_left_changed(seconds_left: int) -> void:
	seconds_between_hour_label.text = "Next hour in = %d" % seconds_left


func on_question_answer_changed(index: int) -> void:
	answered_questions.text = "Answered questions = %s" % index


func on_dificultly_changed(difficulty: String) -> void:
	difficulty_label.text = "Difficulty = %s" % difficulty


func on_allowed_strikes_changed(allowed_strikes_count: int) -> void:
	allowed_strikes_label.text = "Allowed strikes = %s" % allowed_strikes_count


func on_wrongly_answered_changed(wrongly_answered_count: int) -> void:
	wrongly_answered_label.text = "Wrongly answered = %s" % wrongly_answered_count


func on_correctly_answered_changed(correctly_answered_count: int) -> void:
	correctly_answered_label.text = "Correctly answered = %s" % correctly_answered_count


func _on_win_pressed() -> void:
	win_button_pressed.emit()


func _on_lose_pressed() -> void:
	lose_button_pressed.emit()


func _on_time_passed_pressed() -> void:
	time_passed_buttton_pressed.emit()


func _on_jumpscare_on_pressed() -> void:
	jumpscare_on_button_pressed.emit()


func _on_jumpscare_off_pressed() -> void:
	jumpscare_off_button_pressed.emit()


func _on_random_question_pressed() -> void:
	random_question_button_pressed.emit()


func _on_toggle_time_pressed() -> void:
	is_time_stopped = !is_time_stopped
	time_button.text = "Stop time"

	if is_time_stopped:
		time_button.text = "Start time"

	stop_time_button_pressed.emit()
