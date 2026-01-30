extends CharacterBody2D

<<<<<<< HEAD
<<<<<<< HEAD
@export var speed := 200.0
=======
@export var speed := 300.0
>>>>>>> 95e84a24448d13c08566a86103336e83fb0cf5ec
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
=======
@export var speed: float = 300.0

func _physics_process(_delta):
	# Получаем направление движения
	var direction = Vector2.ZERO
	
	if Input.is_action_pressed("ui_right"):
		direction.x += 1
	if Input.is_action_pressed("ui_left"):
		direction.x -= 1
	if Input.is_action_pressed("ui_down"):
		direction.y += 1
	if Input.is_action_pressed("ui_up"):
		direction.y -= 1
	
	# Нормализуем направление (чтобы диагональ не была быстрее)
	direction = direction.normalized()
	
	# Устанавливаем скорость
	velocity = direction * speed
	
	# Двигаем персонажа
	move_and_slide()
>>>>>>> meow
