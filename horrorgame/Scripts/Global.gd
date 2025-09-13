extends Node

var day := 1
var current_job := ""
var ration_level := 100
var weather := "Clear"
var job_order_shown := false
var inventory_open := false
var mail_shown := false

# Local inventory simulation
var rations := 0
var parts := 0
var letters := []

var job_order_scene := preload("res://Scenes/jobOrder.tscn")
var job_order_instance: CanvasLayer = null

func advance_day():
	day += 1
	current_job = generate_job_for_day(day)

	# Simulate daily deliveries
	rations += 1
	parts += 2
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
