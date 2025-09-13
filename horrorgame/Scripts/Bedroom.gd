extends Node2D


#MAIL DELIVERY AT START OF DAY
func _ready():
	Global.advance_day()
	
	if not Global.mail_shown:
		show_mail_notification()
		Global.mail_shown = true  # Mark it as shown

func show_mail_notification():
	$TextureRect/MailLabel.text = "YOU HAVE MAIL"
	$TextureRect/MailLabel.visible = true
	await get_tree().create_timer(2.0).timeout
	$TextureRect/MailLabel.visible = false

func _on_button_pressed():
	var fade_scene = preload("res://Scenes/FadeLayer.tscn")
	var fade = fade_scene.instantiate()
	add_child(fade)
	await fade.fade_out(0.5, func():
		get_tree().change_scene_to_file("res://Scenes/Hallway.tscn")
	)
