extends Area2D

var player_in_range = false
var sign_text = "Добро пожаловать в наш особняк!\n\nЗдесь вы можете отдохнуть и увидеть самые впечатляющие произведения искусства."

func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body):
	if body is CharacterBody2D:
		player_in_range = true
		Global.show_interaction_prompt("Нажмите E чтобы поговорить")

func _on_body_exited(body):
	if body is CharacterBody2D:
		player_in_range = false
		Global.hide_interaction_prompt()

func _process(_delta):
	if player_in_range and Input.is_action_just_pressed("interact"):
		read_sign()

func read_sign():
	Global.show_dialog(
		sign_text,
		[
			{
				"text": "Понятно",
				"callback": func(): Global.show_message("Вы уже поговорили с этим персонажем", 1.0)
			}
		]
	)
