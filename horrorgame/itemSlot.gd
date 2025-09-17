extends Control

signal item_clicked(item_id: String)

var item_id := ""
var quantity := 0

func _ready():
    mouse_filter = Control.MOUSE_FILTER_STOP

    var button := get_node("TextureButton")
   

func initialize(id: String, icon: Texture, count: int):
    item_id = id
    quantity = count
    name = id  # Useful for GridContainer lookup or replacement

    var button := get_node("TextureButton")
    if button:
        if icon:
            button.texture_normal = icon
        button.custom_minimum_size = Vector2(64, 64)

    var label := get_node("Label")
    if label:
        label.text = str(count)

    button.mouse_filter = Control.MOUSE_FILTER_STOP
    button.disabled = false
    button.visible = true
    button.connect("pressed", Callable(self, "_on_texture_button_pressed"))

    print("Initialized ItemSlot:", item_id)

func _on_texture_button_pressed():
    print("Button pressed inside ItemSlot:", item_id)
    emit_signal("item_clicked", item_id)

func _input(event):
    if event is InputEventMouseButton and event.pressed:
        print("ItemSlot received raw click:", item_id)
    
