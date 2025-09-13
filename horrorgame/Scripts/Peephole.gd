extends Node2D

func _ready():
	HUD.inventory_button.visible = false
	HUD.quest_label.visible= false

func _on_button_pressed():
	var fade_scene = preload("res://Scenes/FadeLayer.tscn")
	var fade = fade_scene.instantiate()
	add_child(fade)
	await fade.fade_out(0.5, func():
		get_tree().change_scene_to_file("res://Scenes/mainDoor.tscn")
		HUD.inventory_button.visible = true
		HUD.quest_label.visible= GameState.mailbox_checked
	)
