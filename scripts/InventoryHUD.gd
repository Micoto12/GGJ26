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
	show()
	update_display()

# Главная функция добавления предмета
func add_item(item_name: String, texture: Texture = null, count: int = 1) -> bool:
	print("Добавляем в инвентарь: ", item_name, " x", count)
	
	# Сначала ищем, есть ли уже такой предмет
	for i in range(items.size()):
		if items[i]["name"] == item_name:
			items[i]["count"] += count
			update_slot(i)
			print("✓ Увеличили количество в слоте ", i+1, " до ", items[i]["count"])
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
			print("✓ Добавили в пустой слот ", i+1)
			return true
	
	print("✗ Нет свободных слотов!")
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

# Получить количество конкретного предмета
func get_item_count(item_name: String) -> int:
	var total = 0
	for item in items:
		if item["name"] == item_name:
			total += item["count"]
	print("Количество ", item_name, " в инвентаре: ", total)
	return total

# Проверить наличие предмета
func has_item(item_name: String, min_count: int = 1) -> bool:
	var total = get_item_count(item_name)
	print("Проверка наличия ", item_name, " (нужно ", min_count, ", есть ", total, "): ", total >= min_count)
	return total >= min_count

# Удалить предмет
func remove_item(item_name: String, count: int = 1) -> bool:
	print("Пытаемся удалить: ", item_name, " x", count)
	
	# Сначала проверяем, достаточно ли предметов
	if get_item_count(item_name) < count:
		print("✗ Недостаточно предметов для удаления")
		return false
	
	# Удаляем предметы из слотов
	var remaining = count
	for i in range(items.size()):
		if items[i]["name"] == item_name:
			if items[i]["count"] >= remaining:
				items[i]["count"] -= remaining
				if items[i]["count"] <= 0:
					items[i] = {"name": "", "count": 0, "texture": null}
				update_slot(i)
				print("✓ Удалили ", count, " предметов из слота ", i+1)
				return true
			else:
				remaining -= items[i]["count"]
				items[i] = {"name": "", "count": 0, "texture": null}
				update_slot(i)
	
	print("✗ Не удалось удалить предмет")
	return false

# Получить список всех предметов (для отладки)
func get_items() -> Array:
	var result = []
	for item in items:
		if item["name"] != "":
			result.append(item.duplicate())
	print("Все предметы в инвентаре: ", result)
	return result
