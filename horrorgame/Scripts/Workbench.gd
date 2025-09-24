extends Node2D


func _ready():
	HUD.inventory_button.visible = false
	$WorkbenchDragLayer.add_to_group("active_drag_layer") 

	var workbench_grid := $WorkbenchInventoryGrid
	workbench_grid.scale = Vector2(0.8, 0.8)
	workbench_grid.visible = false

	for item_id in Global.get_inventory_keys():
		var item_data = Global.get_item_data(item_id)

		
		
func _on_inventory_workbench_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		var grid := $WorkbenchInventoryGrid
		grid.toggle_inventory()

		# ✅ Re-register WorkbenchDragLayer when inventory is opened
		if $WorkbenchDragLayer.is_inside_tree():
			if not $WorkbenchDragLayer.is_in_group("active_drag_layer"):
				$WorkbenchDragLayer.add_to_group("active_drag_layer")
				print("✅ DragLayer re-added to group")
		

func _populate_workbench_grid():
	var workbench_grid := $WorkbenchInventoryGrid
	for item_id in Global.get_inventory_keys():
		var item_data = Global.get_item_data(item_id)


func _on_item_clicked(item_id: String) -> void:
	print("Clicked item:", item_id)
	# Optional: unpacking, delivery, inspection logic

func _on_button_pressed(): 
	var fade_scene = preload("res://Scenes/FadeLayer.tscn")
	var fade = fade_scene.instantiate()
	add_child(fade)
	await fade.fade_out(0.5, func():
		get_tree().change_scene_to_file("res://Scenes/mainRoom.tscn")
		HUD.inventory_button.visible = true
	)

		
