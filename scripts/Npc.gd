extends Area2D

var player_in_range = false
var npc_name = "Аркадий"
var dialog_state = 0  # 0 - первая встреча, 1 - задание дано, 2 - задание выполнено

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
	var dialog_text = "АРКАДИЙ: Добро пожаловать на мой вечер, дорогой гость! Я надеюсь, вам нравится атмосфера.\n\nВыберите тему для разговора:"
	
	var options = [
		{
			"text": "«Великолепный вечер, Аркадий. Поздравляю.»",
			"callback": Callable(self, "_on_option_1"),
			"keep_open": true
		},
		{
			"text": "«Ваша коллекция производит сильное впечатление.»",
			"callback": Callable(self, "_on_option_2"),
			"keep_open": true
		},
		{
			"text": "«Вы выглядите немного уставшим от хлопот.»",
			"callback": Callable(self, "_on_option_3"),
			"keep_open": true
		}
	]
	
	if Global != null:
		Global.show_dialog(dialog_text, options)

func _on_option_1():
	var dialog_text = "АРКАДИЙ: «Благодарю, дорогой гость! Да, мы старались. В наше время важно не просто собрать людей, а... поразить их. Оставить след.»\n\nКажется, Аркадий довольно самодоволен и не нуждается в вашей помощи."
	
	var options = [
		{
			"text": "Продолжить осмотр коллекции",
			"callback": Callable()
		}
	]
	
	if Global != null:
		Global.show_dialog(dialog_text, options)

func _on_option_2():
	var dialog_text = "АРКАДИЙ: «Именно так! Искусство должно будоражить кровь, а не просто радовать глаз. Я ищу только самые... острые впечатления.»\n\nАркадий с энтузиазмом рассказывает о своих приобретениях, но не просит о помощи."
	
	var options = [
		{
			"text": "Уйти, оставив его наслаждаться искусством",
			"callback": Callable()
		}
	]
	
	if Global != null:
		Global.show_dialog(dialog_text, options)

func _on_option_3():
	var dialog_text = "АРКАДИЙ (вздрогнув, затем натянуто улыбаясь): «Усталым? О, нет-нет! Просто... предвкушение. Волнение перед показом главных лотов. Горло, знаете ли, даже пересохло от нервов.\n\nНо ничего, скоро шампанское сделает своё дело.\n\nНе могли бы вы сходить до моей домработницы и взять его? Она обычно находится в подсобном помещении.»"
	
	var options = [
		{
			"text": "Конечно, я помогу",
			"callback": Callable(self, "_on_accept_champagne_quest")
		},
		{
			"text": "Извините, я занят",
			"callback": Callable(self, "_on_decline_quest")
		}
	]
	
	if Global != null:
		Global.show_dialog(dialog_text, options)

func _on_accept_champagne_quest():
	dialog_state = 1
	var dialog_text = "АРКАДИЙ: «Прекрасно! Домработница Мария должна быть в подсобке за главным залом. Скажите ей, что шампанское для меня. И побыстрее, пожалуйста!»"
	
	var options = [
		{
			"text": "Хорошо, я отправляюсь",
			"callback": Callable(self, "_on_quest_accepted")
		},
		{
			"text": "А как выглядит Мария?",
			"callback": Callable(self, "_on_ask_about_maid"),
			"keep_open": true
		}
	]
	
	if Global != null:
		Global.show_dialog(dialog_text, options)

func _on_ask_about_maid():
	var dialog_text = "АРКАДИЙ: «Мария? О, она в темно-синем униформе с белым фартуком. Невысокая, с седыми волосами, собранными в пучок. Вы точно ее узнаете - она всегда что-то протирает или поправляет.»"
	
	var options = [
		{
			"text": "Понял, иду искать Марию",
			"callback": Callable(self, "_on_quest_accepted")
		},
		{
			"text": "А где именно подсобка?",
			"callback": Callable(self, "_on_ask_about_location"),
			"keep_open": true
		}
	]
	
	if Global != null:
		Global.show_dialog(dialog_text, options)

func _on_ask_about_location():
	var dialog_text = "АРКАДИЙ: «Пройдите через главный зал, затем налево в коридор. Там будет дверь с табличкой 'Служебное помещение'. Но не задерживайтесь там - это не для гостей.»"
	
	var options = [
		{
			"text": "Ясно, отправляюсь",
			"callback": Callable(self, "_on_quest_accepted")
		}
	]
	
	if Global != null:
		Global.show_dialog(dialog_text, options)

func _on_quest_accepted():
	if Global != null:
		Global.show_message("Задание принято: Найти домработницу Марию и взять шампанское для Аркадия", 2.0)

func show_quest_dialog():
	var dialog_text = "АРКАДИЙ: «Вы уже нашли Марию и шампанское? Мне уже не терпится сделать глоток... Это успокоит нервы перед главным событием.»"
	
	var options = [
		{
			"text": "Да, вот шампанское",
			"callback": Callable(self, "_on_complete_quest"),
			"keep_open": true
		},
		{
			"text": "Еще нет, все ищу",
			"callback": Callable(self, "show_search_hints"),
			"keep_open": true
		},
		{
			"text": "Я передумал помогать",
			"callback": Callable(self, "_on_cancel_quest")
		}
	]
	
	if Global != null:
		Global.show_dialog(dialog_text, options)

func show_search_hints():
	var dialog_text = "АРКАДИЙ: «Мария должна быть в подсобке за главным залом. Пройдите через зал, затем налево в коридор. Ищите дверь с табличкой 'Служебное помещение'.»\n\nОн нервно поправляет галстук."
	
	var options = [
		{
			"text": "Хорошо, продолжу поиски",
			"callback": Callable()
		},
		{
			"text": "А какое шампанское нужно?",
			"callback": Callable(self, "_on_ask_about_champagne"),
			"keep_open": true
		}
	]
	
	if Global != null:
		Global.show_dialog(dialog_text, options)

func _on_ask_about_champagne():
	var dialog_text = "АРКАДИЙ: «О, только Moët & Chandon, разумеется! Я заказывал его специально для этого вечера. Мария знает - бутылки с золотой этикеткой.»"
	
	var options = [
		{
			"text": "Понял, ищу Moët & Chandon",
			"callback": Callable()
		}
	]
	
	if Global != null:
		Global.show_dialog(dialog_text, options)

func _on_complete_quest():
	# Проверяем наличие шампанского в инвентаре
	if Global != null:
		var champagne_count = Global.get_item_count("Шампанское Moët & Chandon")
		
		if champagne_count >= 1:
			# Удаляем шампанское из инвентаря
			var success = Global.remove_item_from_inventory("Шампанское Moët & Chandon", 1)
			if success:
				dialog_state = 2
				var dialog_text = "АРКАДИЙ (с облегчением): «Ах, наконец-то! Спасибо вам, дорогой друг!»\n\nОн быстро откупоривает бутылку и наливает себе бокал.\n\n«Вы спасли ситуацию! В качестве благодарности - вот вам небольшой подарок. И, конечно, вы останетесь на показ главных лотов!»"
				
				var options = [
					{
						"text": "Спасибо, с удовольствием останусь",
						"callback": Callable(self, "_on_reward_given")
					}
				]
				
				Global.show_dialog(dialog_text, options)
			else:
				var dialog_text = "АРКАДИЙ: «Что-то пошло не так... У вас же есть шампанское? Проверьте еще раз.»"
				
				var options = [
					{
						"text": "Проверить инвентарь",
						"callback": Callable()
					}
				]
				
				Global.show_dialog(dialog_text, options)
		else:
			var dialog_text = "АРКАДИЙ: «Но... где же шампанское? Вы же сказали, что нашли его! Может, Мария дала вам что-то другое? Это должна быть бутылка Moët & Chandon с золотой этикеткой.»\n\nОн выглядит разочарованным."
			
			var options = [
				{
					"text": "Извините, я еще поищу",
					"callback": Callable()
				},
				{
					"text": "Расскажите еще раз про Марию",
					"callback": Callable(self, "_on_ask_about_maid"),
					"keep_open": true
				}
			]
			
			Global.show_dialog(dialog_text, options)

func _on_reward_given():
	# Добавляем награду
	if Global != null:
		# Даем награду за выполнение задания
		Global.add_to_hud("Дорогой сигарный набор", "res://assets/player.png", 1)  # Можно заменить на свою текстуру
		Global.show_message("Получено: Дорогой сигарный набор от Аркадия", 2.0)

func _on_decline_quest():
	var dialog_text = "АРКАДИЙ: «Жаль... очень жаль. Что ж, придется обойтись без шампанского или найти кого-то другого.»\n\nОн отворачивается, явно раздосадованный."
	
	var options = [
		{
			"text": "Уйти",
			"callback": Callable()
		}
	]
	
	if Global != null:
		Global.show_dialog(dialog_text, options)

func _on_cancel_quest():
	dialog_state = 0
	var dialog_text = "АРКАДИЙ: «Как невежливо с вашей стороны! Сначала предлагаете помощь, а затем отказываетесь. Пожалуйста, не мешайте мне готовиться к вечеру.»\n\nОн явно обижен."
	
	var options = [
		{
			"text": "Извините",
			"callback": Callable()
		}
	]
	
	if Global != null:
		Global.show_dialog(dialog_text, options)

func show_completion_dialog():
	var dialog_text = "АРКАДИЙ (с бокалом в руке): «Ах, это вы! Спасибо еще раз за помощь. Шампанское великолепно, как и всегда. Наслаждайтесь вечером! Сколько начнется показ главных лотов.»\n\nОн кажется гораздо более расслабленным."
	
	var options = [
		{
			"text": "Приятного вечера!",
			"callback": Callable()
		}
	]
	
	if Global != null:
		Global.show_dialog(dialog_text, options)
