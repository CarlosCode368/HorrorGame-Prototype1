extends Control
class_name WorkbenchItemSlot

signal item_clicked(item_id: String)

var item_id := ""
var quantity := 0
var dragging := false
var original_position := Vector2.ZERO
var original_parent: Control = null
var original_index := -1
var original_grid: Control = null

func _ready():
	set_process(true)
	mouse_filter = Control.MOUSE_FILTER_STOP
	custom_minimum_size = Vector2(64, 64)
	call_deferred("_check_drag_layer")

	var button := get_node("TextureButton")
	if button:
		button.pressed.connect(_on_texture_button_pressed)

func _check_drag_layer():
	var drag_layer := get_drag_layer()
	if drag_layer:
		print("✅ DragLayer found via group:", drag_layer.name)
	else:
		print("❌ DragLayer not found via group")

func initialize(id: String, icon: Texture2D, count: int, grid: Control, drag_group: String = "drag_layer"):
	item_id = id
	quantity = count
	name = id
	original_grid = grid
	set_meta("drag_group", drag_group)

	var button := get_node("TextureButton")
	if button:
		button.texture_normal = icon
		button.custom_minimum_size = Vector2(64, 64)
		button.mouse_filter = Control.MOUSE_FILTER_STOP
		button.disabled = false
		button.visible = true

	var label := get_node("Label")
	if label:
		label.text = str(count)

func _gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
			print("🖱️ Right-click detected on:", item_id)
			emit_signal("item_clicked", item_id)
			return

		elif event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				if dragging:
					return

				var drag_layer := get_drag_layer()
				if drag_layer == null:
					print("❌ DragLayer not found, aborting drag")
					return

				# ✅ Store metadata BEFORE reparenting
				original_parent = get_parent()
				original_index = original_parent.get_children().find(self)
			

				set_meta("original_parent", original_parent)
				set_meta("original_index", original_index)
				set_meta("original_position", original_position)

				original_parent.remove_child(self)
				drag_layer.add_child(self)

				set_position(Vector2.ZERO)
				set_scale(Vector2.ONE)
				set_rotation(0)

				position = get_viewport().get_mouse_position() - size / 2
				z_index = 100
				dragging = true
				Global.currently_dragged_item = self

				var visual_node := get_node_or_null("WorkbenchTextureButton")
				if visual_node:
					visual_node.modulate = Color(1, 1, 1, 0.7)
					visual_node.scale = Vector2(1.1, 1.1)

				print("✅ Dragging started:", item_id)

			else:
				if dragging:
					var drag_layer := get_drag_layer()
					if drag_layer == null:
						print("❌ DragLayer not found on drag end")
						return

					drag_layer.remove_child(self)

					var crafting_slot = Global.crafting_slot
					if crafting_slot and crafting_slot.get_global_rect().has_point(get_global_mouse_position()):
						crafting_slot.add_child(self)
						var local_mouse_pos = crafting_slot.get_local_mouse_position()
						position = local_mouse_pos - size / 2
						print("✅ Dropped into CraftingSlot:", item_id)
					else:
						var return_parent = get_meta("original_parent")
						var return_index = get_meta("original_index")

						if return_parent and return_parent is Control:
							return_parent.add_child(self)
							if return_index != null and return_index >= 0:
								return_parent.move_child(self, return_index)

							# ✅ Reset layout hints to avoid snapping
							anchor_left = 0
							anchor_top = 0
							anchor_right = 0
							anchor_bottom = 0
							offset_left = 0
							offset_top = 0

							print("✅ Reattached to original:", item_id, "at index", return_index)
						else:
							print("⚠️ Original parent missing or invalid. Using fallback.")
							Global.item_grid.add_child(self)

					dragging = false
					Global.currently_dragged_item = null
					z_index = 0

					var visual_node := get_node_or_null("WorkbenchTextureButton")
					if visual_node:
						visual_node.modulate = Color(1, 1, 1, 1)
						visual_node.scale = Vector2(1, 1)
						print("🎨 Reset visuals for:", item_id)

					print("✅ Drag ended and visuals reset:", item_id)

func _process(delta):
	if dragging:
		position = get_viewport().get_mouse_position() - size / 2

func get_drag_layer() -> Control:
	if not is_inside_tree():
		return null

	var group := "drag_layer"
	if has_meta("drag_group"):
		group = str(get_meta("drag_group"))

	var nodes := get_tree().get_nodes_in_group(group)
	for node in nodes:
		if node is Control and node.is_visible_in_tree():
			return node
	return null

func _on_texture_button_pressed():
	print("🖱️ WorkbenchTextureButton pressed on:", item_id)

	# Simulate drag start
	var fake_event := InputEventMouseButton.new()
	fake_event.button_index = MOUSE_BUTTON_LEFT
	fake_event.pressed = true
	_gui_input(fake_event)
