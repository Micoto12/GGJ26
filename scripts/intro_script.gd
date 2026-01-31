extends Node2D

# Ссылки на NPC
@onready var npc_moving = get_node_or_null("NPCMoving")
@onready var npc_static = get_node_or_null("NPCStatic")

func _ready():
	# Проверяем, что узлы существуют
	print("Загрузка сцены заставки...")
	print("Поиск NPC...")
	
	if not npc_moving:
		print("Ошибка: NPCMoving не найден!")
		# Пытаемся найти по другим именам
		npc_moving = get_node_or_null("CharacterBody2D")
	
	if not npc_static:
		print("Ошибка: NPCStatic не найден!")
		# Пытаемся найти по другим именам
		npc_static = get_node_or_null("CharacterBody2D2")
	
	if not npc_moving or not npc_static:
		print("Не удалось найти NPC!")
		print("Доступные узлы:")
		for child in get_children():
			print("- ", child.name)
		return
	
	print("NPC найдены!")
	print("NPCMoving: ", npc_moving.name)
	print("NPCStatic: ", npc_static.name)
	print("Позиция NPCStatic: ", npc_static.global_position)
	
	# Устанавливаем точку подхода (рядом со статичным NPC)
	var approach_point = npc_static.global_position + Vector2(50, 0)
	print("Целевая точка: ", approach_point)
	
	# Устанавливаем цель для движущегося NPC
	if npc_moving.has_method("set_target_position"):
		npc_moving.set_target_position(approach_point)
	else:
		print("Ошибка: у NPCMoving нет метода set_target_position!")
		return
	
	# Ждем немного перед началом движения
	await get_tree().create_timer(1.0).timeout
	
	print("Запуск движения...")
	
	# Запускаем движение
	if npc_moving.has_method("set_approach_state"):
		npc_moving.set_approach_state(true)
	else:
		print("Ошибка: у NPCMoving нет метода set_approach_state!")
		return
	
	# Подключаемся к сигналу достижения цели
	if npc_moving.has_signal("target_reached"):
		npc_moving.target_reached.connect(_on_npc_reached_target)
	else:
		print("Предупреждение: у NPCMoving нет сигнала target_reached")
	
	print("Настройка завершена. NPC должен начать движение.")

func _on_npc_reached_target():
	print("NPC достиг цели!")
	
	# Можно начать специальный диалог для заставки
	if npc_moving.has_method("talk_to_npc"):
		npc_moving.talk_to_npc()
