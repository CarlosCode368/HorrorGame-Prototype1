extends CanvasLayer

@onready var quest_label = $QuestLabel 
@onready var inventory_button = $InventoryButton

func _ready() -> void:
	quest_label.visible = false
	
func show_quest_label():
	quest_label.visible = true
	
#  You can call this method whenever a new letter is added  
func update_quest_display():
	var latest_letter: String = ""
	if Global.letters.size() > 0:
		latest_letter = Global.letters[-1]
		quest_label.text = "📜 Orders:\n" + latest_letter
	
func _on_inventory_button_pressed():
	Global.inventory_open = !Global.inventory_open
	InventoryUI.visible = Global.inventory_open
	print("Inventory toggled:", Global.inventory_open)
	
	
	
	

	
