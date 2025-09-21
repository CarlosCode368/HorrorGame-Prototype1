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
        # 🖱️ Right-click to unpack
        if event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
            print("🖱️ Right-click detected on:", item_id)
            emit_signal("item_clicked", item_id)
            return

        # 👈 Left-click to drag
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

                # 🧼 Reset transform to avoid rendering issues
                set_position(Vector2.ZERO)
                set_scale(Vector2.ONE)
                set_rotation(0)

                # 🖱️ Position in UI space
                position = get_viewport().get_mouse_position() - size / 2
                z_index = 100
                modulate = Color(1, 1, 1, 0.7)
                scale = Vector2(1.1, 1.1)
                dragging = true
                print("✅ Dragging started:", item_id)

            else:
                if dragging:
                    var drag_layer := get_drag_layer()
                    if drag_layer == null:
                        print("❌ DragLayer not found on drag end")
                        return

                    drag_layer.remove_child(self)

                    if original_parent == null:
                        print("❌ original_parent is null on drag end")
                        return

                    original_parent.add_child(self)
                    if original_index >= 0:
                        original_parent.move_child(self, original_index)

                    global_position = original_position
                    z_index = 0
                    modulate = Color(1, 1, 1, 1)
                    scale = Vector2(1, 1)
                    dragging = false
                    print("✅ Reattached successfully:", item_id)

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
            print("✅ DragLayer found via group:", group)
            return node
    return null
    
