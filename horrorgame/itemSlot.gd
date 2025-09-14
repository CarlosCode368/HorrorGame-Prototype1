extends Control

var item_id := ""
var quantity := 0

func initialize(id: String, icon: Texture, count: int):
	print("Initializing slot:", id, "Quantity:", count)
	item_id = id
	quantity = count
	$TextureRect.texture = icon
	$Label.text = str(count)
	
