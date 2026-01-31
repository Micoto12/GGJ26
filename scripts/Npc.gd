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
			# Первая встреча
			show_first_dialog()
		1:
			# После получения задания
			show_quest_dialog()
		2:
			# После выполнения задания
			show_completion_dialog()

func show_first_dialog():
	var dialog_text = npc_name + ": Привет, путник! Я страж этих земель.\n\nВижу, ты ищешь приключений? У меня есть для тебя задание."
	
	var options = [
		{
			"text": "Какое задание?",
			"callback": Callable(self, "show_quest_explanation"),
			"keep_open": true  # Диалог не закроется
		},
		{
			"text": "Я просто прохожу мимо",
			"callback": Callable(self, "_on_decline_quest")
		},
		{
			"text": "У меня есть вопросы",
			"callback": Callable(self, "show_questions_menu"),
			"keep_open": true
		}
	]
	
	if Global != null:
		Global.show_dialog(dialog_text, options)

func show_quest_explanation():
	var dialog_text = npc_name + ": Мне нужны 3 волшебных кристалла для древнего ритуала защиты замка.\n\nТы найдешь их в сундуках по всему замку. Как найдешь - принеси мне."
	
	var options = [
		{
			"text": "Хорошо, я займусь поисками",
			"callback": Callable(self, "_on_accept_quest_final")
		},
		{
			"text": "А где именно искать?",
			"callback": Callable(self, "show_search_hints"),
			"keep_open": true
		},
		{
			"text": "А что за ритуал?",
			"callback": Callable(self, "show_ritual_info"),
			"keep_open": true
		}
	]
	
	if Global != null:
		Global.show_dialog(dialog_text, options)

func _on_accept_quest_final():
	dialog_state = 1
	var dialog_text = npc_name + ": Отлично! Иди и ищи кристаллы в сундуках. Как только найдешь 3 - возвращайся ко мне."
	
	var options = [
		{
			"text": "Понял, отправляюсь на поиски",
			"callback": Callable()
		}
	]
	
	if Global != null:
		Global.show_dialog(dialog_text, options)
		Global.show_message("Задание принято: Найти 3 волшебных кристалла", 2.0)

func show_search_hints():
	var dialog_text = npc_name + ": Кристаллы спрятаны в сундуках по всему замку.\n\nОсмотри все комнаты, включая подвалы и чердаки. Обычно сундуки находятся в углах или за колоннами."
	
	var options = [
		{
			"text": "А как выглядят кристаллы?",
			"callback": Callable(self, "show_crystal_appearance"),
			"keep_open": true
		},
		{
			"text": "Хорошо, буду искать",
			"callback": Callable(self, "_on_accept_quest_final")
		},
		{
			"text": "Назад",
			"callback": Callable(self, "show_quest_explanation"),
			"keep_open": true
		}
	]
	
	if Global != null:
		Global.show_dialog(dialog_text, options)

func show_crystal_appearance():
	var dialog_text = npc_name + ": Волшебные кристаллы светятся мягким голубым светом.\n\nОни размером с кулак и имеют идеальную геометрическую форму. Их трудно спутать с чем-то другим!"
	
	var options = [
		{
			"text": "Теперь я знаю, что искать",
			"callback": Callable(self, "_on_accept_quest_final")
		},
		{
			"text": "Назад к подсказкам",
			"callback": Callable(self, "show_search_hints"),
			"keep_open": true
		}
	]
	
	if Global != null:
		Global.show_dialog(dialog_text, options)

func show_ritual_info():
	var dialog_text = npc_name + ": Это древний ритуал защиты замка от темных сил.\n\nКристаллы обладают магической силой, которая усиливает оборонительные заклинания. Без них замок будет уязвим."
	
	var options = [
		{
			"text": "Теперь я понимаю важность задания",
			"callback": Callable(self, "_on_accept_quest_final")
		},
		{
			"text": "Назад",
			"callback": Callable(self, "show_quest_explanation"),
			"keep_open": true
		}
	]
	
	if Global != null:
		Global.show_dialog(dialog_text, options)

func show_questions_menu():
	var dialog_text = npc_name + ": О чем ты хочешь спросить?"
	
	var options = [
		{
			"text": "Где найти зелья?",
			"callback": Callable(self, "show_potions_info"),
			"keep_open": true
		},
		{
			"text": "Кто правит этими землями?",
			"callback": Callable(self, "show_king_info"),
			"keep_open": true
		},
		{
			"text": "Назад",
			"callback": Callable(self, "show_first_dialog"),
			"keep_open": true
		}
	]
	
	if Global != null:
		Global.show_dialog(dialog_text, options)

func show_potions_info():
	var dialog_text = npc_name + ": В лесу растут целебные травы, из которых можно приготовить зелья.\n\nТакже иногда торговцы привозят зелья из дальних стран. Но сейчас не время для торговцев."
	
	var options = [
		{
			"text": "Спасибо за информацию",
			"callback": Callable(self, "show_questions_menu"),
			"keep_open": true
		}
	]
	
	if Global != null:
		Global.show_dialog(dialog_text, options)

func show_king_info():
	var dialog_text = npc_name + ": Этими землями правит король Артур, мудрый и справедливый правитель.\n\nОн поручил мне защищать этот участок границы от любых угроз."
	
	var options = [
		{
			"text": "Слава королю Артуру!",
			"callback": Callable(self, "show_questions_menu"),
			"keep_open": true
		}
	]
	
	if Global != null:
		Global.show_dialog(dialog_text, options)

func _on_decline_quest():
	var dialog_text = npc_name + ": Жаль. Если передумаешь - я всегда здесь.\n\nБудь осторожен в своих путешествиях."
	
	var options = [
		{
			"text": "До свидания",
			"callback": Callable()
		}
	]
	
	if Global != null:
		Global.show_dialog(dialog_text, options)

func show_quest_dialog():
	var dialog_text = npc_name + ": Ты уже нашел волшебные кристаллы?\n\nМне нужно 3 кристалла для ритуала."
	
	var options = [
		{
			"text": "Да, вот они",
			"callback": Callable(self, "_on_complete_quest"),
			"keep_open": true  # Не закрываем, чтобы показать результат
		},
		{
			"text": "Еще нет, я все ищу",
			"callback": Callable(self, "show_encouragement"),
			"keep_open": true
		},
		{
			"text": "Отменить задание",
			"callback": Callable(self, "show_cancel_confirmation"),
			"keep_open": true
		}
	]
	
	if Global != null:
		Global.show_dialog(dialog_text, options)

func show_encouragement():
	var dialog_text = npc_name + ": Не сдавайся! Кристаллы точно где-то в замке.\n\nПроверь все сундуки, которые найдешь. Они могут быть в самых неожиданных местах."
	
	var options = [
		{
			"text": "Хорошо, продолжу поиски",
			"callback": Callable()
		}
	]
	
	if Global != null:
		Global.show_dialog(dialog_text, options)

func show_cancel_confirmation():
	var dialog_text = npc_name + ": Ты уверен, что хочешь отменить задание?\n\nБез ритуала защиты замок может оказаться в опасности."
	
	var options = [
		{
			"text": "Да, отменить",
			"callback": Callable(self, "_on_cancel_quest")
		},
		{
			"text": "Нет, продолжу поиски",
			"callback": Callable(self, "show_quest_dialog"),
			"keep_open": true
		}
	]
	
	if Global != null:
		Global.show_dialog(dialog_text, options)

func _on_complete_quest():
	# Проверяем наличие кристаллов в инвентаре
	if Global != null:
		var crystal_count = Global.get_item_count("Волшебный кристалл")
		
		if crystal_count >= 3:
			# Удаляем кристаллы из инвентаря
			var success = Global.remove_item_from_inventory("Волшебный кристалл", 3)
			if success:
				dialog_state = 2
				var dialog_text = npc_name + ": Отлично! Ты нашел все 3 кристалла!\n\nСпасибо за помощь. Вот твоя награда - 50 золотых монет.\n\nТеперь я могу провести ритуал защиты."
				
				var options = [
					{
						"text": "Спасибо! Удачи с ритуалом",
						"callback": Callable(self, "_on_reward_given")
					}
				]
				
				Global.show_dialog(dialog_text, options)
			else:
				var dialog_text = npc_name + ": Произошла ошибка при передаче кристаллов.\n\nПопробуй еще раз."
				
				var options = [
					{
						"text": "Понятно",
						"callback": Callable()
					}
				]
				
				Global.show_dialog(dialog_text, options)
		else:
			var dialog_text = npc_name + ": У тебя недостаточно кристаллов! Нужно 3, а у тебя всего " + str(crystal_count) + ".\n\nПродолжай поиски в сундуках по замку."
			
			var options = [
				{
					"text": "Хорошо, продолжу поиски",
					"callback": Callable()
				},
				{
					"text": "Где еще можно поискать?",
					"callback": Callable(self, "show_encouragement"),
					"keep_open": true
				}
			]
			
			Global.show_dialog(dialog_text, options)

func _on_reward_given():
	# Добавляем награду
	if Global != null:
		Global.add_to_hud("Золотые монеты", "res://assets/wood_tile.png", 50)
		Global.show_message("Получено: 50 золотых монет", 2.0)

func _on_cancel_quest():
	dialog_state = 0
	var dialog_text = npc_name + ": Очень жаль. Если передумаешь - возвращайся.\n\nБез кристаллов ритуал не провести."
	
	var options = [
		{
			"text": "До свидания",
			"callback": Callable()
		}
	]
	
	if Global != null:
		Global.show_dialog(dialog_text, options)

func show_completion_dialog():
	var dialog_text = npc_name + ": Спасибо еще раз за помощь!\n\nРитуал защиты успешно проведен. Если понадобится еще помощь - обращайся."
	
	var options = [
		{
			"text": "Хорошо, удачи!",
			"callback": Callable()
		}
	]
	
	if Global != null:
		Global.show_dialog(dialog_text, options)
