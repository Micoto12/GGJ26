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
<<<<<<< HEAD
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
=======
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
>>>>>>> d1c9d18e51db28b1e8f627694d89f10d3ca43c4a
			items[i] = {
				"name": item_name,
				"count": count,
				"texture": texture
			}
			update_slot(i)
			return true
<<<<<<< HEAD
	
	print("Нет свободных слотов!")
	return false

# Обновить слот
=======
		elif items[i]["name"] == item_name:
			# Предмет уже есть - увеличиваем количество
			items[i]["count"] += count
			update_slot(i)
			return true
	
	print("Нет свободных слотов в инвентаре!")
	return false

# Обновить конкретный слот
>>>>>>> d1c9d18e51db28b1e8f627694d89f10d3ca43c4a
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

<<<<<<< HEAD
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
=======
# Получить список всех предметов
>>>>>>> d1c9d18e51db28b1e8f627694d89f10d3ca43c4a
func get_items() -> Array:
	var result = []
	for item in items:
		if item["name"] != "":
			result.append(item.duplicate())
	return result
<<<<<<< HEAD
=======

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
>>>>>>> d1c9d18e51db28b1e8f627694d89f10d3ca43c4a
