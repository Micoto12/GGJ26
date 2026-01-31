extends Area2D

var player_in_range = false
var npc_name = "Страж"
var dialog_state = 0  # 0 - первая встреча, 1 - после получения задания, 2 - после выполнения

func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body):
	if body is CharacterBody2D:
		player_in_range = true
		if Global != null:
			Global.show_interaction_prompt("Нажмите E чтобы поговорить")

func _on_body_exited(body):
	if body is CharacterBody2D:
		player_in_range = false
		if Global != null:
			Global.hide_interaction_prompt()

func _process(delta):
	if player_in_range and Input.is_action_just_pressed("interact"):
		talk_to_npc()

func talk_to_npc():
	match dialog_state:
		0:
			show_first_dialog()
		1:
			show_quest_dialog()
		2:
			show_completion_dialog()

func show_first_dialog():
	var dialog_text = npc_name + ": Привет, путник! Я страж этих земель.\n\nВижу, ты ищешь приключений? У меня есть для тебя задание."
	
	var options = [
		{
			"text": "Какое задание?",
			"callback": Callable(self, "_on_accept_quest")
		},
		{
			"text": "Я просто прохожу мимо",
			"callback": Callable(self, "_on_decline_quest")
		}
	]
	
	if Global != null:
		Global.show_dialog(dialog_text, options)

func show_quest_dialog():
	var dialog_text = npc_name + ": Ты уже нашел волшебные кристаллы?\n\nМне нужно 3 кристалла для ритуала."
	
	var options = [
		{
			"text": "Да, вот они",
			"callback": Callable(self, "_on_complete_quest")
		},
		{
			"text": "Еще нет, я все ищу",
			"callback": Callable(self, "_on_quest_in_progress")
		},
		{
			"text": "Отменить задание",
			"callback": Callable(self, "_on_cancel_quest")
		}
	]
	
	if Global != null:
		Global.show_dialog(dialog_text, options)

func show_completion_dialog():
	var dialog_text = npc_name + ": Спасибо за помощь! Теперь я могу провести ритуал.\n\nЕсли понадобится еще помощь - обращайся."
	
	var options = [
		{
			"text": "Хорошо, удачи!",
			"callback": Callable(self, "_on_goodbye")
		}
	]
	
	if Global != null:
		Global.show_dialog(dialog_text, options)

func _on_accept_quest():
	dialog_state = 1
	if Global != null:
		Global.show_message("Получен квест: Найти 3 волшебных кристалла")

func _on_decline_quest():
	if Global != null:
		Global.show_message("Страж: Тогда удачи в пути!", 2.0)

func _on_complete_quest():
	# Проверяем наличие кристаллов в инвентаре
	if Global != null:
		var crystal_count = Global.get_item_count("Волшебный кристалл")
		print("NPC: Проверяем кристаллы. Найдено: ", crystal_count)
		
		if crystal_count >= 3:
			# Удаляем кристаллы из инвентаря
			var success = Global.remove_item_from_inventory("Волшебный кристалл", 3)
			if success:
				dialog_state = 2
				Global.show_message("Задание выполнено! Награда: 100 золотых монет.", 3.0)
				# Даем награду
				Global.add_to_hud("Золотая монета", "res://assets/wood_tile.png", 100)
			else:
				Global.show_message("Произошла ошибка при сдаче кристаллов", 2.0)
		else:
			Global.show_message("У вас недостаточно кристаллов! Нужно 3, а у вас всего " + str(crystal_count), 3.0)

func _on_quest_in_progress():
	if Global != null:
		Global.show_message("Страж: Ищи в сундуках или пещере на востоке", 2.0)

func _on_cancel_quest():
	dialog_state = 0
	if Global != null:
		Global.show_message("Задание отменено", 2.0)

func _on_goodbye():
	if Global != null:
		Global.show_message("Вы попрощались со стражем", 2.0)
