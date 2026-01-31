extends Area2D

class_name Chest

signal interaction

var player_in_range = false
var was_opened = false
var item_name = "Золотая монета"
var item_description = "Блестящая золотая монета.\nМожно продать за 10 золотых."

func _ready():
	print("Сундук готов!")
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body):
	if body is CharacterBody2D and not was_opened:
		player_in_range = true
		print("Игрок в зоне сундука")
		Global.show_interaction_prompt("Нажмите E чтобы открыть")

func _on_body_exited(body):
	if body is CharacterBody2D:
		player_in_range = false
		print("Игрок вышел из зоны сундука")
		Global.hide_interaction_prompt()

func _process(_delta):
	if player_in_range and Input.is_action_just_pressed("interact") and not was_opened:
		open_chest()

func open_chest():
	print("=== ОТКРЫВАЕМ СУНДУК ===")
	interaction.emit()
	was_opened = true
	
	# Визуальный эффект открытия
	if has_node("Sprite2D"):
		$Sprite2D.modulate = Color(0.5, 0.5, 0.5)
	
	# Скрываем подсказку
	Global.hide_interaction_prompt()
	
	# Показываем диалог с предметом - он сам закроется после выбора
	Global.show_item_dialog(item_name, item_description)

# Функция для настройки предмета в сундуке
func set_item(name: String, description: String = ""):
	item_name = name
	if description != "":
		item_description = description
