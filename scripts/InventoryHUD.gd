extends CanvasLayer

class_name InventoryHUD

# Ссылки на слоты
@onready var slots: Array = [
	$HBoxContainer/Slot1,
	$HBoxContainer/Slot2,
	$HBoxContainer/Slot3,
	$HBoxContainer/Slot4
]

# Данные предметов в слотах
var items: Array = [
	{"name": "", "count": 0, "texture_path": ""},
	{"name": "", "count": 0, "texture_path": ""},
	{"name": "", "count": 0, "texture_path": ""},
	{"name": "", "count": 0, "texture_path": ""}
]

func _ready():
	print("InventoryHUD готов")
	show()
	update_display()

# Добавить предмет
func add_item(item_name: String, texture: Texture = null, count: int = 1) -> bool:
	print("InventoryHUD: добавляем ", item_name, " x", count)
	
	# Сначала ищем, есть ли уже такой предмет
	for i in range(items.size()):
		if items[i]["name"] == item_name:
			items[i]["count"] += count
			update_slot(i)
			return true
	
	# Если предмет новый, ищем пустой слот
	for i in range(items.size()):
		if items[i]["name"] == "":
			items[i] = {
				"name": item_name,
				"count": count,
				"texture": texture
			}
			update_slot(i)
			return true
	
	print("Нет свободных слотов!")
	return false

# Обновить слот
func update_slot(slot_index: int):
	if slot_index < 0 or slot_index >= slots.size():
		return
	
	var slot = slots[slot_index]
	var item = items[slot_index]
	
	# Иконка
	var icon = slot.get_node("Icon")
	if item["texture"]:
		icon.texture = item["texture"]
		icon.show()
	else:
		icon.hide()
	
	# Количество
	var count_label = slot.get_node("Count")
	if item["count"] > 1:
		count_label.text = str(item["count"])
		count_label.show()
	else:
		count_label.text = ""
		count_label.hide()

# Обновить все слоты
func update_display():
	for i in range(slots.size()):
		update_slot(i)

# Получить количество предмета
func get_item_count(item_name: String) -> int:
	var total = 0
	for item in items:
		if item["name"] == item_name:
			total += item["count"]
	print("InventoryHUD: количество ", item_name, " = ", total)
	return total

# Проверить наличие предмета
func has_item(item_name: String, min_count: int = 1) -> bool:
	var count = get_item_count(item_name)
	return count >= min_count

# Удалить предмет
func remove_item(item_name: String, count: int = 1) -> bool:
	print("InventoryHUD: пытаемся удалить ", item_name, " x", count)
	
	# Проверяем, достаточно ли предметов
	if get_item_count(item_name) < count:
		print("Недостаточно предметов для удаления")
		return false
	
	# Удаляем предметы
	var remaining = count
	for i in range(items.size()):
		if items[i]["name"] == item_name:
			if items[i]["count"] >= remaining:
				items[i]["count"] -= remaining
				if items[i]["count"] <= 0:
					items[i] = {"name": "", "count": 0, "texture": null}
				update_slot(i)
				return true
			else:
				remaining -= items[i]["count"]
				items[i] = {"name": "", "count": 0, "texture": null}
				update_slot(i)
	
	return false

# Получить все предметы
func get_items() -> Array:
	var result = []
	for item in items:
		if item["name"] != "":
			result.append(item.duplicate())
	return result
