extends Control

class_name Clock

signal hour_passed
signal six_am_reached
signal hour_changed(hour_text: String)
signal seconds_left_changed(seconds_left: int)
signal current_hour_changed(hour: int)

const SECONDS_BETWEEN_HOURS: int = 60

@onready var label: Label = %Label
@onready var debugger: Debugger = %Debugger

var current_hour: int = 0
var _run_id: int = 0
var is_paused: bool = false
var seconds_left_in_hour: int = SECONDS_BETWEEN_HOURS
var question_timer = 25


func _ready():
	debugger.time_passed_buttton_pressed.connect(_on_debugger_time_passed_buttton_pressed)
	debugger.stop_time_button_pressed.connect(clock_status)
	GameManager.determine_question_timer.connect(determine_question_timer)

	start()


func start() -> void:
	_run_id += 1
	is_paused = false
	current_hour = 0
	seconds_left_in_hour = SECONDS_BETWEEN_HOURS
	_start_counting.call_deferred(_run_id)
	determine_question_timer()


func stop() -> void:
	_run_id += 1 # invalidates the current loop


func _resume() -> void:
	_run_id += 1
	seconds_left_changed.emit(seconds_left_in_hour)
	_start_counting.call_deferred(_run_id)


func clock_status() -> void:
	is_paused = !is_paused

	if is_paused:
		stop() # invalidate the running loop
	else:
		_resume() # start again from current_hour


func determine_question_timer() -> void:
	print("determine_question_timer - resetting timer for new question")
	# Determine the timer value based on current hour
	if current_hour <= 2:
		question_timer = 25
	elif current_hour <= 4:
		question_timer = 20
	else:
		question_timer = 15

	print("Question timer set to: ", question_timer, " seconds for hour ", current_hour)


func _start_counting(run_id: int):
	# Emit initial hour immediately
	label.text = _get_current_hour_text()
	hour_changed.emit(label.text)
	current_hour_changed.emit(current_hour)

	while current_hour < 6:
		# Count down seconds for this hour
		while seconds_left_in_hour > 0:
			if run_id != _run_id or is_paused:
				return

			seconds_left_changed.emit(seconds_left_in_hour)
			await get_tree().create_timer(1.0).timeout

			if run_id != _run_id or is_paused:
				return

			seconds_left_in_hour -= 1
			question_timer -= 1

			if question_timer == 0:
				GameManager.lose_game()

		if run_id != _run_id:
			return

		# Advance hour
		current_hour += 1
		seconds_left_in_hour = SECONDS_BETWEEN_HOURS
		label.text = _get_current_hour_text()
		hour_changed.emit(label.text)
		hour_passed.emit()
		current_hour_changed.emit(current_hour)

	if run_id == _run_id:
		six_am_reached.emit()


func _get_current_hour_text() -> String:
	if current_hour == 0:
		return "12 AM"
	return str(current_hour) + " AM"


func _on_debugger_time_passed_buttton_pressed() -> void:
	stop()
	current_hour = 6
	seconds_left_in_hour = 0
	label.text = _get_current_hour_text()
	hour_changed.emit(label.text)
	seconds_left_changed.emit(0)
	six_am_reached.emit()
