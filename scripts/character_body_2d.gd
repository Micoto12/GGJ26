extends CharacterBody2D

@export var speed := 300.0
@onready var sprite := $AnimatedSprite2D

func _physics_process(delta):
	var dir := Vector2.ZERO

	if Input.is_key_pressed(KEY_D):
		dir.x += 1
	if Input.is_key_pressed(KEY_A):
		dir.x -= 1
	if Input.is_key_pressed(KEY_S):
		dir.y += 1
	if Input.is_key_pressed(KEY_W):
		dir.y -= 1

	dir = dir.normalized()
	velocity = dir * speed
	move_and_slide()

	if dir != Vector2.ZERO:
		if sprite.animation != "run":
			sprite.play("run")
	else:
		if sprite.animation != "idle":
			sprite.play("idle")

	if dir.x != 0:
		sprite.flip_h = dir.x < 0
