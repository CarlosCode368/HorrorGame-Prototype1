extends Control

var step := 0
var current_visual: Node = null
var delivery_done := false

# Local inventory simulation
var rations := 1
var parts := 1
var letters := []

func set_order_text(text: String):
	$TextureRect/Label.text = text

func _ready():
	HUD.inventory_button.visible = false
	$InputBlocker.visible = true  
	$NextButton.pressed.connect(_on_next_pressed)
	$ReturnButton.pressed.connect(_on_return_pressed)
	$ReturnButton.visible = false

func _on_next_pressed():
	if delivery_done:
		print("🚫 Delivery already completed")
		return

	step += 1
	match step:
		1:
			letters.append($TextureRect/Label.text)
			GameState.mailbox_checked = true
			if HUD:
				HUD.update_quest_display()
			$TextureRect.visible = false
			if rations > 0:
				show_ration()
			else:
				print("No rations, skipping to next")
				_on_next_pressed()
		2:
			if parts > 0:
				show_parts_box()
			else:
				print("No parts, skipping to next")
				_on_next_pressed()
		3:
			print("✅ Showing return button")
			$NextButton.visible = false
			$ReturnButton.visible = true
			delivery_done = true
			

func show_ration():
	if current_visual:
		current_visual.queue_free()
	var ration_scene = preload("res://Scenes/RationsItem.tscn")
	var ration = ration_scene.instantiate()
	get_tree().root.add_child(ration)
	ration.global_position = Vector2(50, 5)
	current_visual = ration

func show_parts_box():
	if current_visual:
		current_visual.queue_free()
	var parts_box_scene = preload("res://Scenes/partsBox.tscn")
	var parts_box = parts_box_scene.instantiate()
	get_tree().root.add_child(parts_box)
	parts_box.global_position = Vector2(1300, 800) # Adjust as needed
	current_visual = parts_box

	$NextButton.visible = false
	$ReturnButton.visible = true
	delivery_done = true

func _on_return_pressed():
	$InputBlocker.visible = false
	HUD.inventory_button.visible = true
	if current_visual:
		current_visual.queue_free()
		
	Global.letters.append($TextureRect/Label.text)  # Push to global now
	if HUD:
		HUD.update_quest_display()
		if GameState.mailbox_checked:
			HUD.show_quest_label()  # Optional: reveal label if hidden
			if rations > 0:
				Global.add_item("rations", preload("res://Assets/Icons/RationsIcon.png"), rations)

			if parts > 0:
				Global.add_item("part_box", preload("res://Assets/Icons/partBoxIcon.png"), parts)
			queue_free()
