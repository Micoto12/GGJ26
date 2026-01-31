extends Camera2D

@export var target: NodePath  # путь на игрока
@export var deadzone_size := Vector2(300, 200)  # ширина и высота зоны преследования
@export var speed := 5.0  # скорость плавного движения камеры

@onready var player = get_node(target)

func _ready():
	make_current()  # теперь камера становится активной правильно

func _process(delta):
	if player == null:
		return

	var cam_pos = global_position
	var player_pos = player.global_position
	var offset = Vector2.ZERO

	# Проверяем X
	if player_pos.x > cam_pos.x + deadzone_size.x / 2.5:
		offset.x = player_pos.x - (cam_pos.x + deadzone_size.x / 2.5)
	elif player_pos.x < cam_pos.x - deadzone_size.x / 2.5:
		offset.x = player_pos.x - (cam_pos.x - deadzone_size.x / 2.5)

	# Проверяем Y
	if player_pos.y > cam_pos.y + deadzone_size.y / 2.5:
		offset.y = player_pos.y - (cam_pos.y + deadzone_size.y / 2.5)
	elif player_pos.y < cam_pos.y - deadzone_size.y / 2.5:
		offset.y = player_pos.y - (cam_pos.y - deadzone_size.y / 2.5)

	# Плавное движение камеры
	global_position += offset * speed * delta
