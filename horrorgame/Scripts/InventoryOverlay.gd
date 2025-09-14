extends CanvasLayer

func _ready():
    layer = 20
    visible = false
    print("InventoryOverlay ready. Visible:", visible)

    # Optional: force background visibility for debugging
    $ColorRect.size = Vector2(800, 600)

func toggle_inventory():
    print("TOGGLE INVENTORY FUNCTION CALLED")
    visible = true
    populate_inventory($ColorRect/GridContainer)
    print("Overlay visibility:", visible)

func _on_inventory_back_button_pressed() -> void:
    Global.inventory_open = false
    visible = false
    print("Inventory closed via back button.")

func populate_inventory(grid: GridContainer):
    print("Populating inventory...")

    # Clear previous slots
    for child in grid.get_children():
        grid.remove_child(child)
        child.queue_free()

    var keys = Global.inventory.keys()
    print("Inventory keys at populate:", keys)

    for item_id in keys:
        var item_data = Global.inventory[item_id]
        print("Adding item:", item_id, "Icon is null:", item_data["icon"] == null)

        var slot = preload("res://Scenes/ItemSlot.tscn").instantiate()
        slot.initialize(item_id, item_data["icon"], item_data["quantity"])
        grid.add_child(slot)
    
