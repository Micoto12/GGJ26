extends CharacterBody2D

@export var speed := 100.0
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

# запоминаем последнее направление (для idle)
var last_dir := Vector2.DOWN

func _physics_process(delta):
	var input_dir := Vector2.ZERO

	# --- Ввод WASD ---
	if Input.is_key_pressed(KEY_W):
		input_dir.y -= 1
	if Input.is_key_pressed(KEY_S):
		input_dir.y += 1
	if Input.is_key_pressed(KEY_A):
		input_dir.x -= 1
	if Input.is_key_pressed(KEY_D):
		input_dir.x += 1

	input_dir = input_dir.normalized()

	# --- Движение ---
	velocity = input_dir * speed
	move_and_slide()

	# --- Анимации ---
	if input_dir == Vector2.ZERO:
		play_idle()
	else:
		last_dir = input_dir
		play_run(input_dir)

func play_run(dir: Vector2):
	if abs(dir.x) > abs(dir.y):
		if dir.x > 0:
			sprite.play("run_right")
		else:
			sprite.play("run_left")
	else:
		if dir.y > 0:
			sprite.play("run_front")
		else:
			sprite.play("run_back")

func play_idle():
	if abs(last_dir.x) > abs(last_dir.y):
		if last_dir.x > 0:
			sprite.play("idle_right")
		else:
			sprite.play("idle_left")
	else:
		if last_dir.y > 0:
			sprite.play("idle_front")
		else:
			sprite.play("idle_back")
