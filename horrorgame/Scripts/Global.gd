extends Node

signal inventory_updated  # Optional: for UI auto-refresh

var day := 1
var current_job := ""
var ration_level := 100
var weather := "Clear"
var job_order_shown := false
var inventory_open := false
var mail_shown := false
var letters := []

var inventory := {}  # item_id → {icon, quantity}

# Centralized icon registry for inventory visuals
var item_icons := {
    "rations": preload("res://Assets/Icons/RationsIcon.png"),
    "parts": preload("res://Assets/Icons/RationsIcon.png")
}

var job_order_scene := preload("res://Scenes/jobOrder.tscn")
var job_order_instance: CanvasLayer = null

func _ready():
    print("Global ready. Inventory keys:", inventory.keys())

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

func advance_day():
    day += 1
    current_job = generate_job_for_day(day)
    
    letters.append(current_job)

    if HUD:
        HUD.update_quest_display()

func generate_job_for_day(day: int) -> String:
    match day:
        0: return "Build 5 parts"
        1: return "Assemble TYPE-3 Core"
        2: return "Repair transistor"
        _: return "Classified Task"

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
