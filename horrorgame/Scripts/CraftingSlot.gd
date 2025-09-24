extends TextureRect

var buttons_spawned := false
var original_position := Vector2.ZERO

func _ready():
	Global.crafting_slot = self
	print("✅ CraftingSlot registered:", self.name)

func _gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		if Global.currently_dragged_item:
			accept_item(Global.currently_dragged_item)
			Global.currently_dragged_item = null

func accept_item(item):
	if not item:
		return

	# Save original parent, position, and index BEFORE reparenting
	item.set_meta("original_parent", item.get_parent())
	item.set_meta("original_position", item.global_position)
	item.set_meta("original_index", item.get_parent().get_children().find(item))

	item.get_parent().remove_child(item)
	add_child(item)

	var local_mouse_pos = get_local_mouse_position()
	item.position = local_mouse_pos - item.size / 2

	item.dragging = false
	Global.currently_dragged_item = null

	var visual_node: TextureButton = item.get_node_or_null("TextureButton")
	if visual_node:
		visual_node.modulate = Color(1, 1, 1, 1)
		visual_node.scale = Vector2(1, 1)

	item.mouse_filter = Control.MOUSE_FILTER_IGNORE
	item.set_process_input(false)
	item.set_process(false)
	item.set_meta("locked_in_slot", true)

	if item.has_meta("item_id"):
		print("🔒 Item locked in crafting slot:", item.get_meta("item_id"))

	if not buttons_spawned:
		spawn_action_buttons()
		buttons_spawned = true

func spawn_action_buttons():
	var craft_button = Button.new()
	craft_button.text = "CRAFT"
	craft_button.anchor_left = 0
	craft_button.anchor_top = 0
	craft_button.anchor_right = 0
	craft_button.anchor_bottom = 0
	craft_button.offset_left = -10
	craft_button.offset_top = 140
	craft_button.connect("pressed", Callable(self, "_on_craft_pressed"))
	add_child(craft_button)

	var cancel_button = Button.new()
	cancel_button.text = "CANCEL"
	cancel_button.anchor_left = 1
	cancel_button.anchor_top = 1
	cancel_button.anchor_right = 1
	cancel_button.anchor_bottom = 1
	cancel_button.offset_left = -50
	cancel_button.offset_top = 8
	cancel_button.connect("pressed", Callable(self, "_on_cancel_pressed"))
	add_child(cancel_button)

func _on_craft_pressed():
	print("🛠️ Crafting initiated!")
	# Add your crafting logic here

func _on_cancel_pressed():
	print("❌ Crafting canceled!")

	var items_to_return := []

	# Collect items locked in the crafting slot
	for child in get_children():
		if child.has_meta("locked_in_slot") and child.get_meta("locked_in_slot"):
			items_to_return.append(child)

	# Remove action buttons
	for child in get_children():
		if child is Button:
			remove_child(child)
			child.queue_free()

	buttons_spawned = false

	# Return items to their original parent and index
	for item in items_to_return:
		remove_child(item)

		var original_parent = item.get_meta("original_parent")
		var original_index = item.get_meta("original_index")
	

		if original_parent and original_parent is Control:
			original_parent.add_child(item)

			# Restore to original index in GridContainer
			if original_index != null and original_index >= 0:
				original_parent.move_child(item, original_index)

			print("✅ Returned", item.name, "to", original_parent.name, "at index", original_index)
		else:
			print("⚠️ Original parent missing or invalid. Using fallback grid.")
			Global.item_grid.add_child(item)

		# Restore interactivity
		item.mouse_filter = Control.MOUSE_FILTER_PASS
		item.set_process_input(true)
		item.set_process(true)
		item.set_meta("locked_in_slot", false)
		item.dragging = false

		# Reset visuals
		var visual_node: TextureButton = item.get_node_or_null("TextureButton")
		if visual_node:
			visual_node.modulate = Color(1, 1, 1, 1)
			visual_node.scale = Vector2(1, 1)
	
