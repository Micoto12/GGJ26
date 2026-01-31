extends Area2D

@export var linked_door: Node2D  # сюда в инспекторе перетащить DoorB/ DoorA

var player_in_area: CharacterBody2D = null  # хранит игрока, когда он рядом

func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node):
	if body.is_in_group("player"):
		player_in_area = body
		print("Игрок рядом с дверью:", body.name)

func _on_body_exited(body: Node):
	if body == player_in_area:
		player_in_area = null
		print("Игрок ушёл от двери:", body.name)

func _process(delta):
	if player_in_area and Input.is_key_pressed(KEY_E):
		if linked_door:
			player_in_area.global_position = linked_door.global_position + Vector2(32, 0)
			print("Телепортирован к двери:", linked_door.name)
