extends Node2D

func _on_button_pressed():
	#Transition Script
	var fade_scene = preload("res://Scenes/FadeLayer.tscn")
	var fade = fade_scene.instantiate()
	add_child(fade)
	await fade.fade_out(0.5, func():
		#Returns to Main Room
		get_tree().change_scene_to_file("res://Scenes/mainRoom.tscn")
	)

func _on_bedroom_door_area_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed:
		var fade_scene = preload("res://Scenes/FadeLayer.tscn")
		var fade = fade_scene.instantiate()
		add_child(fade)
		await fade.fade_out(0.5, func():
			get_tree().change_scene_to_file("res://Scenes/Bedroom.tscn")
		)


func _on_kitchen_door_area_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		var fade_scene = preload("res://Scenes/FadeLayer.tscn")
		var fade = fade_scene.instantiate()
		add_child(fade)
		await fade.fade_out(0.5, func():
			get_tree().change_scene_to_file("res://Scenes/Kitchen.tscn") 
		)
