extends Area2D

var player_in_range = false
var was_opened = false
var chest_type = "golden"  # golden, silver, wooden

func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body):
	if body is CharacterBody2D and not was_opened:
		player_in_range = true
		if Global != null:
			Global.show_interaction_prompt("Нажмите E чтобы открыть")

func _on_body_exited(body):
	if body is CharacterBody2D:
		player_in_range = false
		if Global != null:
			Global.hide_interaction_prompt()

func _process(delta):
	if player_in_range and Input.is_action_just_pressed("interact") and not was_opened:
		open_chest()

func open_chest():
	was_opened = true
	
	# Визуальный эффект
	if has_node("Sprite2D"):
		$Sprite2D.modulate = Color(0.5, 0.5, 0.5)
	
	if Global != null:
		Global.hide_interaction_prompt()
	
	# Определяем содержимое сундука
	var item_data = get_chest_contents()
	
	# Показываем диалог с предметом
	show_chest_contents_dialog(item_data)

func get_chest_contents() -> Dictionary:
	var item_name = ""
	var item_description = ""
	var item_count = 1
	var texture_path = ""
	var chest_color = ""
	
	match chest_type:
		"golden":
			chest_color = "золотой"
			item_name = "Волшебный кристалл"
			item_description = "Сияющий магический кристалл, излучающий мягкий свет. Необходим для ритуалов."
			# Фиксированное количество для тестирования
			item_count = 4
			texture_path = "res://assets/player.png"  # Используем player.png как текстуру для кристалла
		
		"silver":
			chest_color = "серебряный"
			item_name = "Ключ"
			item_description = "Старый железный ключ. Возможно, откроет какую-то дверь."
			item_count = 1
			texture_path = "res://assets/player.png"
		
		"wooden":
			chest_color = "деревянный"
			item_name = "Зелье здоровья"
			item_description = "Красное зелье, восстанавливающее здоровье."
			item_count = randi_range(1, 3)
			texture_path = "res://assets/tileset.png"
	
	return {
		"chest_color": chest_color,
		"item_name": item_name,
		"item_description": item_description,
		"item_count": item_count,
		"texture_path": texture_path
	}

func show_chest_contents_dialog(item_data: Dictionary):
	var dialog_text = "Вы открыли {chest_color} сундук.\n\nВнутри вы видите: {item_name}.\n\n{item_description}".format({
		"chest_color": item_data["chest_color"],
		"item_name": item_data["item_name"],
		"item_description": item_data["item_description"]
	})
	
	# Добавляем информацию о количестве, если больше 1
	if item_data["item_count"] > 1:
		dialog_text += "\n\nКоличество: {count} шт.".format({"count": item_data["item_count"]})
	
	var options = [
		{
			"text": "Взять {item_name}{count_text}".format({
				"item_name": item_data["item_name"],
				"count_text": " (x{count})".format({"count": item_data["item_count"]}) if item_data["item_count"] > 1 else ""
			}),
			"item_data": {
				"name": item_data["item_name"],
				"texture": item_data["texture_path"],
				"count": item_data["item_count"]
			}
		},
		{
			"text": "Оставить в сундуке",
			"callback": Callable(self, "_on_leave_item")
		}
	]
	
	if Global != null:
		Global.show_dialog(dialog_text, options)

func _on_leave_item():
	# Игрок решил оставить предмет в сундуке
	if Global != null:
		Global.show_message("Вы оставили предмет в сундуке", 2.0)
	
	# Возвращаем визуал сундука к полуоткрытому состоянию
	if has_node("Sprite2D"):
		$Sprite2D.modulate = Color(0.7, 0.7, 0.7)
	
	# Устанавливаем флаг, что сундук еще можно открыть
	was_opened = false

# Функция для сброса сундука (если нужно использовать повторно)
func reset_chest():
	was_opened = false
	if has_node("Sprite2D"):
		$Sprite2D.modulate = Color(1, 1, 1)
	
	print("Сундук сброшен и готов к открытию")

# Функция для проверки, открыт ли сундук
func is_opened() -> bool:
	return was_opened
