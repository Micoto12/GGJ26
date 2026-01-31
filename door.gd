extends Area2D

<<<<<<< HEAD
@export var linked_door: Area2D  # ссылка на другую дверь
var player_in_area: CharacterBody2D = null
var can_teleport: bool = true
=======
@export var linked_door: Node2D

var player_in_area: CharacterBody2D = null
var can_teleport: bool = true  # флаг, который блокирует мгновенный повтор
>>>>>>> 01f045608a680495eae5b6e4a76cb51785bee4cf

func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node):
	if body.is_in_group("player"):
		player_in_area = body

func _on_body_exited(body: Node):
	if body == player_in_area:
		player_in_area = null

func _process(delta):
	if player_in_area and can_teleport and Input.is_key_pressed(KEY_E):
		if linked_door:
<<<<<<< HEAD
			# Получаем CollisionShape двери
			var shape = linked_door.get_node("CollisionShape2D").shape
			var center_offset = Vector2.ZERO

			# Проверяем тип формы
			if shape is RectangleShape2D:
				center_offset = shape.extents
			elif shape is CircleShape2D:
				center_offset = Vector2(shape.radius, shape.radius)
			# Можно добавить другие формы по необходимости

			# Телепортируем игрока в центр коллизии
			player_in_area.global_position = linked_door.global_position
			print("Телепортирован в центр двери:", linked_door.name)

			# Блокировка повторного телепорта
			can_teleport = false
=======
			# телепортируем игрока
			player_in_area.global_position = linked_door.global_position + Vector2(32, 0)
			print("Телепортирован к двери:", linked_door.name)
			
			# блокируем телепорт на 0.3 секунды
			can_teleport = false
			# запускаем таймер через await
>>>>>>> 01f045608a680495eae5b6e4a76cb51785bee4cf
			await get_tree().create_timer(0.3).timeout
			can_teleport = true
