extends SceneTree

func _init() -> void:
	var gm_script: Script = preload("res://Autoloads/GameManager.gd")
	var gm: Node = gm_script.new() as Node
	root.add_child(gm)

	gm.connect("question_pool_empty", func(diff): print("[TEST] pool empty:", diff))
	gm.connect("question_changed", func(q): print("[TEST] Q:", String(q).left(40)))
	gm.connect("difficulty_changed", func(d): print("[TEST] diff:", d))

	gm.call("start_run")

	for hour in [0, 1, 2, 3, 4, 5]:
		print("\n[TEST] --- hour =", hour, "---")
		gm.call("on_hour_changed", hour)

		for i in range(999):
			if gm.get("run_over"):
				print("[TEST] run over")
				quit()
				return

			var data: Dictionary = gm.get("current_question_data")
			var correct := int(data.get("correct", -1))
			if correct < 0:
				print("[TEST] no correct index")
				break

			gm.call("player_answer", correct, 0)

	print("[TEST] done")
	quit()
