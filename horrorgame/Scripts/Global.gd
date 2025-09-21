extends Node

signal inventory_updated

var day := 1
var current_job := ""
var ration_level := 100
var weather := "Clear"
var job_order_shown := false
var inventory_open := false
var mail_shown := false
var letters := []

var inventory := {}  # item_id → {icon, quantity}
var item_icons := {
	"rations": preload("res://Assets/Icons/RationsIcon.png"),
	"part_box": preload("res://Assets/Icons/partBoxIcon.png"),
	"part_battery_cell": preload("res://Assets/Icons/partBatteryCellIcon.png"),
	"part_wires": preload("res://Assets/Icons/partWiresIcon.png")
}

var job_order_scene := preload("res://Scenes/jobOrder.tscn")
var job_order_instance: CanvasLayer = null

func _ready():
	print("Global ready. Inventory keys:", inventory.keys())

# Inventory Management
func add_item(id: String, icon: Texture = null, quantity: int = 1):
	if icon == null and item_icons.has(id):
		icon = item_icons[id]

	if inventory.has(id):
		inventory[id]["quantity"] += quantity
	else:
		inventory[id] = {
			"icon": icon,
			"quantity": quantity
	}
	print("Item added:", id, "Quantity:", inventory[id]["quantity"])
	emit_signal("inventory_updated")

func remove_item(id: String, quantity: int = 1):
	if inventory.has(id):
		inventory[id]["quantity"] -= quantity
		if inventory[id]["quantity"] <= 0:
			inventory.erase(id)
			print("Item removed completely:", id)
		else:
			print("Item reduced:", id, "New quantity:", inventory[id]["quantity"])
		emit_signal("inventory_updated")

func get_inventory_keys() -> Array:
	return inventory.keys()

func get_item_data(id: String) -> Dictionary:
	if inventory.has(id):
		return inventory[id]
	return {}

func deliver_mail_items(items: Array):
	for item_id in items:
		add_item(item_id)
	print("Mail delivered:", items)

# Quest System
func advance_day():
	day += 1
	current_job = generate_job_for_day(day)
	letters.append(current_job)
	if HUD:
		HUD.update_quest_display()

func generate_job_for_day(day: int) -> String:
	match day:
		_: return "Build 1 Battery Pack"

# Job Order UI
func show_job_order():
	if job_order_instance == null:
		job_order_instance = job_order_scene.instantiate()
		get_tree().root.add_child(job_order_instance)
		job_order_instance.visible = false

	job_order_instance.visible = true
	job_order_instance.set_order_text(current_job)

func hide_job_order():
	if job_order_instance:
		job_order_instance.visible = false
