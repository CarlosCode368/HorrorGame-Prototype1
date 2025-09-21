extends GridContainer

func _ready():
    # Sync with global inventory updates
    Global.connect("inventory_updated", Callable(self, "refresh"))
    refresh()

func refresh():
    # Clear existing slots
    for child in get_children():
        remove_child(child)
        child.queue_free()

    # Populate with current inventory
    for item_id in Global.get_inventory_keys():
        var item_data = Global.get_item_data(item_id)
        var slot := create_slot(item_id, item_data)
        add_child(slot)

func create_slot(item_id: String, item_data: Dictionary) -> Control:
    var slot := preload("res://Scenes/ItemSlot.tscn").instantiate()
    slot.initialize(item_id, item_data["icon"], item_data["quantity"], self, "drag_layer")  # ✅ Pass drag group
    slot.connect("item_clicked", Callable(self, "_on_item_clicked"))
    return slot

func _on_item_clicked(item_id: String):
    print("Workbench item clicked:", item_id)

    if item_id == "part_box":
        print("Unpacking part_box...")
        Global.remove_item(item_id)
        Global.add_item("part_battery_cell")
        Global.add_item("part_wires")
        refresh()
    else:
        print("Clicked:", item_id)
