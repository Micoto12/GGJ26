extends Area2D

signal interaction

var player_in_range = false

func _ready():
	print("Сундук готов! Ожидаю игрока...")
	
	# Подключаем сигналы
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	
	# Проверяем коллайдер
	if has_node("CollisionShape2D"):
		var shape = $CollisionShape2D.shape
		if shape:
			print("Размер коллайдера: ", shape.extents * 2)
		else:
			print("У коллайдера нет формы!")
	else:
		print("У сундука нет CollisionShape2D!")

func _on_body_entered(body):
	print("Что-то вошло в зону! Тип: ", body.get_class(), " Имя: ", body.name)
	
	# Более гибкая проверка - любой CharacterBody2D
	if body is CharacterBody2D:
		player_in_range = true
		print("ИГРОК В ЗОНЕ!")
		Global.show_interaction_prompt("Нажмите E")
	else:
		print("Это не игрок, а ", body.name)

func _on_body_exited(body):
	if body is CharacterBody2D:
		player_in_range = false
		print("Игрок вышел из зоны")
		Global.hide_interaction_prompt()

func _process(_delta):
	if player_in_range and Input.is_action_just_pressed("interact"):

		# Активируем предмет
		interaction.emit()
		
		# Показываем сообщение на экране
		Global.show_message("СУНДУК ОТКРЫТ!")
		
		# Отключаем дальнейшее взаимодействие
		player_in_range = false
		Global.hide_interaction_prompt()
		
		# Можно добавить эффекты:
		$Sprite2D.modulate = Color(0.5, 0.5, 0.5)  # Затемнение
		interaction.emit()
