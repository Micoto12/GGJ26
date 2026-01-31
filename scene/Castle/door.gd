# Door.gd
extends Area2D

@export var linked_door: Area2D
@export var interact_key: String = "e"

var player_in_area: Node2D = null

func _ready():
	# подключаем сигналы Area2D
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node):
	if body.is_in_group("player"):
		player_in_area = body

func _on_body_exited(body: Node):
	if body == player_in_area:
		player_in_area = null

func _process(delta):
	if player_in_area and Input.is_action_just_pressed(interact_key):
		if linked_door:
			# телепортируем игрока рядом с дверью
			player_in_area.global_position = linked_door.global_position + Vector2(32, 0)
