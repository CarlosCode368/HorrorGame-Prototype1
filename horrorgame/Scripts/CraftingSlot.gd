extends TextureRect


func _ready():
    Global.crafting_slot = self
    print("✅ CraftingSlot registered:", self.name)

func _gui_input(event):
    if event is InputEventMouseButton and event.pressed:
                if Global.currently_dragged_item:
                    accept_item(Global.currently_dragged_item)
                    Global.currently_dragged_item = null
                    
func accept_item(item):
    item.get_parent().remove_child(item)
    add_child(item)

    # Position item inside the slot
    var local_mouse_pos = get_local_mouse_position()
    item.position = local_mouse_pos - item.size / 2

    # Reset drag state
    item.dragging = false
    Global.currently_dragged_item = null

    # ✅ Reset visuals
    var visual_node: TextureButton = item.get_node_or_null("TextureButton")
    if visual_node:
        visual_node.modulate = Color(1, 1, 1, 1)
        visual_node.scale = Vector2(1, 1)
        print("🎨 Reset visuals for:", item.item_id)
