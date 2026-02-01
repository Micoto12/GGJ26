# maid.gd - для домработницы Марии
extends Area2D

var player_in_range = false
var has_champagne = true  # У Марии есть шампанское

func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body):
	if body is CharacterBody2D and has_champagne:
		player_in_range = true
		if Global != null:
			Global.show_interaction_prompt("Нажмите E чтобы поговорить с Марией")

func _on_body_exited(body):
	if body is CharacterBody2D:
		player_in_range = false
		if Global != null:
			Global.hide_interaction_prompt()

func _process(delta):
	if player_in_range and Input.is_action_just_pressed("interact") and has_champagne:
		talk_to_maid()

func talk_to_maid():
	var dialog_text = "МАРИЯ: «О, вы от Аркадия? Он уже забеспокоился? Да, вот шампанское. Только аккуратнее, не трясите!»"
	
	var options = [
		{
			"text": "Взять шампанское",
			"callback": Callable(self, "_give_champagne"),
			"item_data": {
				"name": "Шампанское Moët & Chandon",
				"texture": "res://assets/champagne.png",  # Используйте вашу текстуру
				"count": 1
			}
		},
		{
			"text": "Спросить о вечере",
			"callback": Callable(self, "_on_ask_about_party"),
			"keep_open": true
		}
	]
	
	if Global != null:
		Global.show_dialog(dialog_text, options)

func _give_champagne():
	has_champagne = false
	if Global != null:
		Global.show_message("Мария отдает вам шампанское", 2.0)

func _on_ask_about_party():
	var dialog_text = "МАРИЯ: «Аркадий всегда так нервничает перед своими мероприятиями. Каждый раз одно и то же - то освещение не то, то шампанское не той температуры... Слава богу, сегодня хоть гости вежливые.»"
	
	var options = [
		{
			"text": "Вернуться к шампанскому",
			"callback": Callable(self, "talk_to_maid"),
			"keep_open": true
		},
		{
			"text": "Поблагодарить и уйти",
			"callback": Callable()
		}
	]
	
	if Global != null:
		Global.show_dialog(dialog_text, options)
