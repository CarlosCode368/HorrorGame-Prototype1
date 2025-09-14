extends CanvasLayer

@onready var quest_label = $QuestLabel 
@onready var inventory_button = $InventoryButton

var inventory_overlay_scene := preload("res://Scenes/InventoryOverlay.tscn")
var inventory_instance: CanvasLayer = null  # Renamed to avoid conflict

func _ready() -> void:
    quest_label.visible = false

    inventory_instance = inventory_overlay_scene.instantiate()
    add_child(inventory_instance)
    inventory_instance.visible = false

func show_quest_label():
    quest_label.visible = true

func update_quest_display():
    var latest_letter: String = ""
    if Global.letters.size() > 0:
        latest_letter = Global.letters[-1]
        quest_label.text = "📜 Orders:\n" + latest_letter

func _on_inventory_button_pressed():
    Global.inventory_open = !Global.inventory_open
    inventory_instance.visible = Global.inventory_open
    print("Inventory toggled:", Global.inventory_open)

    if Global.inventory_open:
        inventory_instance.toggle_inventory()
    
    
    
    

    
