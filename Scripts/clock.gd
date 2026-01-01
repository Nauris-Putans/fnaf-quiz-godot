extends Control

signal hour_passed
signal six_am_reached
signal hour_changed(hour_text: String)
signal seconds_left_changed(seconds_left: int)

const SECONDS_BETWEEN_HOURS : int = 5

@onready var label: Label = %Label

var current_hour : int = 0
var _run_id: int = 0

func _ready():
	start()
	_start_counting.call_deferred(_run_id)

func start() -> void:
	_run_id += 1
	current_hour = 0
	_start_counting.call_deferred(_run_id)

func stop() -> void:
	_run_id += 1 # invalidates the current loop

func _start_counting(run_id: int):
	# Emit initial hour immediately
	label.text = _get_current_hour_text()
	hour_changed.emit(label.text)

	while current_hour < 6:
		# Count down seconds for this hour
		for seconds_left in range(SECONDS_BETWEEN_HOURS, 0, -1):
			if run_id != _run_id:
				return
			seconds_left_changed.emit(seconds_left)
			await get_tree().create_timer(1.0).timeout

		if run_id != _run_id:
			return
		
		# Advance hour
		current_hour += 1
		label.text = _get_current_hour_text()
		hour_changed.emit(label.text)
		hour_passed.emit()

	if run_id == _run_id:
		six_am_reached.emit()

func _get_current_hour_text() -> String:
	if current_hour == 0:
		return "12 AM"
	else:
		return str(current_hour) + " AM"

func _on_debugger_time_passed_buttton_pressed() -> void:
	current_hour = 6
	label.text = _get_current_hour_text()
	hour_changed.emit(label.text)
	seconds_left_changed.emit(0)
	six_am_reached.emit()
