extends Node2D

#TO GO BACK
func _on_button_pressed():
    var fade_scene = preload("res://Scenes/FadeLayer.tscn")
    var fade = fade_scene.instantiate()
    add_child(fade)
    await fade.fade_out(0.5, func():
        get_tree().change_scene_to_file("res://Scenes/mainRoom.tscn")
    )
    
func _on_peephole_input_event(viewport:Node,event:InputEvent,shape_idx:int) -> void:
     if event is InputEventMouseButton and event.pressed:
        var fade_scene = preload("res://Scenes/FadeLayer.tscn")
        var fade = fade_scene.instantiate()
        add_child(fade)
        await fade.fade_out(0.5, func():
            get_tree().change_scene_to_file("res://Scenes/Peephole.tscn")
         
        )
