extends Control
class_name ItemSlot

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
    call_deferred("_check_drag_layer")

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

                original_parent = get_parent()
                if original_parent == null:
                    print("❌ original_parent is null on drag start")
                    return

                original_index = original_parent.get_children().find(self)
                original_position = global_position

                original_parent.remove_child(self)
                drag_layer.add_child(self)

                set_position(Vector2.ZERO)
                set_scale(Vector2.ONE)
                set_rotation(0)

                position = get_viewport().get_mouse_position() - size / 2
                z_index = 100
                dragging = true
                Global.currently_dragged_item = self

                # Apply drag visuals
                var visual_node := get_node_or_null("TextureButton")
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
                        original_parent.add_child(self)
                        if original_index >= 0:
                            original_parent.move_child(self, original_index)
                        global_position = original_position
                        print("✅ Reattached to original:", item_id)

                    # Reset visuals and drag state
                    dragging = false
                    Global.currently_dragged_item = null
                    z_index = 0

                    var visual_node := get_node_or_null("TextureButton")
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
    
