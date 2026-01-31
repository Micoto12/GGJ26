extends Panel
class_name InventorySlot

@onready var icon: TextureRect = $TextureRect
@onready var count_label: Label = $Label

var item_name: String = ""
var count: int = 0

func is_empty() -> bool:
	return item_name == ""

func set_item(name: String, texture: Texture2D = null, amount: int = 1):
	item_name = name
	count = amount
	icon.texture = texture
	icon.visible = true
	update_label()

func add(amount: int = 1):
	count += amount
	update_label()

func clear():
	item_name = ""
	count = 0
	icon.texture = null
	icon.visible = false
	count_label.text = ""

func update_label():
	if count > 1:
		count_label.text = str(count)
	else:
		count_label.text = ""
