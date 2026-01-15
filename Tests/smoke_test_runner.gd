extends Node

@export var max_steps_per_hour: int = 999
@export var hours_to_simulate: Array[int] = [0, 1, 2, 3, 4, 5]


func _enter_tree() -> void:
	print("[TEST] runner enter_tree")


func _ready() -> void:
	# Make sure autoloads are ready
	await get_tree().process_frame

	# Use the actual autoload singleton (do NOT new() it)
	var gm := GameManager

	# Optional: mute audio so tests don't touch audio stuff
	AudioServer.set_bus_mute(0, true)

	gm.question_pool_empty.connect(
		func(diff: String) -> void:
			print("[TEST] pool empty:", diff)
	)
	gm.question_changed.connect(
		func(q: String) -> void:
			print("[TEST] Q:", q.left(40))
	)
	gm.difficulty_changed.connect(
		func(d: String) -> void:
			print("[TEST] diff:", d)
	)
	gm.game_won.connect(
		func() -> void:
			print("[TEST] GAME WON")
	)
	gm.game_lost.connect(
		func() -> void:
			print("[TEST] GAME LOST")
	)

	gm.start_run()

	for hour: int in hours_to_simulate:
		print("\n[TEST] --- hour =", hour, "---")
		gm.on_hour_changed(hour)

		for i: int in range(max_steps_per_hour):
			if gm.run_over:
				print("[TEST] stop: run_over")
				get_tree().quit()
				return

			if gm.waiting_for_questions:
				print("[TEST] stop: waiting_for_questions")
				break

			var correct := int(gm.current_question_data.get("correct", -1))
			if correct < 0:
				print("[TEST] stop: no correct index")
				break

			gm.player_answer(correct, 0)

	print("[TEST] done. run_over=", gm.run_over, " waiting=", gm.waiting_for_questions)
	get_tree().quit()
