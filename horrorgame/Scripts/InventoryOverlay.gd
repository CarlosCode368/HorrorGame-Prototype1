extends CanvasLayer

func _ready():
	layer = 1  # Lower than GlobalUI's layer = 10
	visible = false
	print("InventoryOverlay ready. Visible:", visible)
	

func toggle_inventory():
	Global.inventory_open = !Global.inventory_open
	visible = Global.inventory_open
	print("Inventory toggled:", visible)


func _on_inventory_back_button_pressed() -> void:
	Global.inventory_open = false
	visible = false
	print("Inventory closed via back button.")
