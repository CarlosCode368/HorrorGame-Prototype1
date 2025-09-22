extends CanvasLayer

func _ready():
	layer = 20
	visible = false
	

func toggle_inventory():
	visible = true
	populate_inventory($InventoryGrid)

func _on_inventory_back_button_pressed() -> void:
	Global.inventory_open = false
	visible = false
	print("Inventory closed via back button.")

func populate_inventory(grid: GridContainer):
	for child in grid.get_children():
		grid.remove_child(child)
		child.queue_free()

	for item_id in Global.inventory.keys():
		var item_data = Global.inventory[item_id]
		var slot = preload("res://Scenes/ItemSlot.tscn").instantiate()
		slot.initialize(item_id, item_data["icon"], item_data["quantity"], grid)  # ✅ Pass grid here
		slot.connect("item_clicked", Callable(self, "_on_item_clicked"))
		print("Connected signal for:", item_id)
		grid.add_child(slot)

func _on_item_clicked(item_id: String):
	print("Item clicked in overlay:", item_id)
	var item_data = Global.inventory.get(item_id)
	if item_data == null:
		print("Item not found:", item_id)
		return
	print("item_id == 'part_box':", item_id == "part_box")
	if item_id == "part_box":
		print("Unpacking part_box...")
		Global.remove_item(item_id)
		Global.add_item("part_battery_cell")
		Global.add_item("part_wires")
		populate_inventory($InventoryGrid)
	else:
		print("Clicked:", item_id)

func replace_item_with_contents(item_id: String, contents: Array):
	var grid := $ColorRect/InventoryGrid
	var index := -1

	for child in grid.get_children():
		if child.name == item_id:
			index = grid.get_children().find(child)
			grid.remove_child(child)
			child.queue_free()
			break

	if index == -1:
		print("Item not found in grid:", item_id)
		return

	for content_id in contents:
		var content_data = Global.inventory.get(content_id)
		if content_data:
			var slot = preload("res://Scenes/ItemSlot.tscn").instantiate()
			slot.initialize(content_id, content_data["icon"], content_data["quantity"])
			slot.connect("item_clicked", Callable(self, "_on_item_clicked"))
			grid.add_child(slot)
			grid.move_child(slot, index)
			index += 1
