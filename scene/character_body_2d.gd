extends CharacterBody2D

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

func _input(event):
	# Открываем инвентарь по I
	if event.is_action_pressed("inventory"):
		Global.toggle_inventory()
