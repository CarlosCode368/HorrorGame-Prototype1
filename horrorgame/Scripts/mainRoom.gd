extends Node2D

var job_order_shown := false

func _on_button_pressed():
	var fade_scene = preload("res://Scenes/FadeLayer.tscn")
	var fade = fade_scene.instantiate()
	add_child(fade)
	await fade.fade_out(0.5, func():
		get_tree().change_scene_to_file("res://Scenes/Hallway.tscn")
	)


func _on_main_door_area_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		var fade_scene = preload("res://Scenes/FadeLayer.tscn")
		var fade = fade_scene.instantiate()
		add_child(fade)
		await fade.fade_out(0.5, func():
			get_tree().change_scene_to_file("res://Scenes/mainDoor.tscn") 
		)


func _on_window_area_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		var fade_scene = preload("res://Scenes/FadeLayer.tscn")
		var fade = fade_scene.instantiate()
		add_child(fade)
		await fade.fade_out(0.5, func():
			get_tree().change_scene_to_file("res://Scenes/Window.tscn") 
		)


func _on_mailbox_area_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		if not Global.job_order_shown:
			show_job_order(Global.current_job)
			Global.job_order_shown = true
		else:
			print("📬 Job order already shown—ignoring click")
		

func show_job_order(order_text: String):
	var job_order_ui = preload("res://Scenes/jobOrder.tscn").instantiate()
	add_child(job_order_ui)  # Must be added before positioning
	job_order_ui.position = $MailboxArea.global_position + Vector2(0, -100)
	job_order_ui.set_order_text(Global.current_job)


func _on_telephone_area_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		var fade_scene = preload("res://Scenes/FadeLayer.tscn")
		var fade = fade_scene.instantiate()
		add_child(fade)
		await fade.fade_out(0.5, func():
			get_tree().change_scene_to_file("res://Scenes/Telephone.tscn") 
		)
		


func _on_shelf_area_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		var fade_scene = preload("res://Scenes/FadeLayer.tscn")
		var fade = fade_scene.instantiate()
		add_child(fade)
		await fade.fade_out(0.5, func():
			get_tree().change_scene_to_file("res://Scenes/Shelf.tscn")
			)


func _on_workbench_area_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		var fade_scene = preload("res://Scenes/FadeLayer.tscn")
		var fade = fade_scene.instantiate()
		add_child(fade)
		await fade.fade_out(0.5, func():
			get_tree().change_scene_to_file("res://Scenes/Workbench.tscn")
			)
