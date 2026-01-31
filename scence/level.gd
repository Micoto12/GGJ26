extends Node2D

@onready var player := $VlChar

func _ready():
	for enemy in get_tree().get_nodes_in_group("enemies"):
		enemy.set_target(player)
