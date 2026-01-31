extends Node2D

@export var target_door: Node2D

@onready var area := $Area2D
@onready var spawn := $SpawnPoint

var player: CharacterBody2D
var locked := false

func _ready():
	area.body_entered.connect(_on_body_entered)
	area.body_exited.connect(_on_body_exited)

func _on_body_entered(body):
	if body.is_in_group("player"):
		player = body
		print("Игрок у двери")

func _on_body_exited(body):
	if body == player:
		player = null

func _physics_process(_delta):
	if player and not locked and Input.is_action_just_pressed("interact"):
		teleport()

func teleport():
	locked = true

	# полностью останавливаем игрока
	player.velocity = Vector2.ZERO

	# телепортируем ВНЕ коллизий
	player.global_position = target_door.get_node("SpawnPoint").global_position

	await get_tree().create_timer(0.2).timeout
	locked = false
