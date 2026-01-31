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
	{"name": "", "count": 0, "texture": null},
	{"name": "", "count": 0, "texture": null},
	{"name": "", "count": 0, "texture": null},
	{"name": "", "count": 0, "texture": null}
]

func _ready():
	print("HUD инвентарь загружен и показан")
	show()  # Убеждаемся, что инвентарь виден
	update_display()

# Добавить предмет в первый свободный слот
func add_item(item_name: String, texture: Texture = null, count: int = 1) -> bool:
	for i in range(slots.size()):
		if items[i]["name"] == "":
			# Найден пустой слот
			items[i] = {
				"name": item_name,
				"count": count,
				"texture": texture
			}
			update_slot(i)
			return true
		elif items[i]["name"] == item_name:
			# Предмет уже есть - увеличиваем количество
			items[i]["count"] += count
			update_slot(i)
			return true
	
	print("Нет свободных слотов в инвентаре!")
	return false

# Обновить конкретный слот
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

# Получить список всех предметов
func get_items() -> Array:
	var result = []
	for item in items:
		if item["name"] != "":
			result.append(item.duplicate())
	return result

# Проверить наличие предмета
func has_item(item_name: String, min_count: int = 1) -> bool:
	for item in items:
		if item["name"] == item_name and item["count"] >= min_count:
			return true
	return false

# Удалить предмет
func remove_item(item_name: String, count: int = 1) -> bool:
	for i in range(items.size()):
		if items[i]["name"] == item_name:
			items[i]["count"] -= count
			
			if items[i]["count"] <= 0:
				# Слот становится пустым
				items[i] = {"name": "", "count": 0, "texture": null}
			
			update_slot(i)
			return true
	
	return false
