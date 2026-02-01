extends CharacterBody2D

# Сигналы
signal target_reached()
signal movement_started()
signal movement_stopped()

# Экспортируемые переменные
@export var npc_name: String = "СЕРГЕЙ"
@export var move_speed: float = 80.0
@export var approach_distance: float = 50.0

# Публичные переменные (доступны извне)
var target_position: Vector2 = Vector2.ZERO
var should_approach: bool = false
var is_moving: bool = false
var is_at_target: bool = false

# Приватные переменные
var player_in_range: bool = false
var current_player = null
var dialogue_started: bool = false
var dialogue_completed: bool = false
var current_dialogue_step: int = 0

# Ссылки на узлы
@onready var interaction_area = $InteractionArea
@onready var sprite = $AnimatedSprite2D

func _ready():
	# Проверяем, есть ли спрайт
	if not sprite:
		sprite = $Sprite2D
	
	# Подключаем сигналы к InteractionArea
	if interaction_area:
		interaction_area.body_entered.connect(_on_interaction_area_body_entered)
		interaction_area.body_exited.connect(_on_interaction_area_body_exited)
		print(npc_name + ": готов к работе")
	else:
		print("ОШИБКА: InteractionArea не найден!")
	
	# Если target_position не задана, используем текущую позицию
	if target_position == Vector2.ZERO:
		target_position = global_position
		
	print("NPC ", npc_name, " инициализирован. Позиция: ", global_position)

func _physics_process(delta):
	# Движение к цели
	if should_approach and not is_at_target:
		move_to_target()
	
	# Проверяем взаимодействие с игроком (в диалоге для продолжения)
	if player_in_range and Input.is_action_just_pressed("interact"):
		if dialogue_started and not dialogue_completed:
			continue_dialogue()
		elif not dialogue_started:
			talk_to_npc()

func move_to_target():
	var direction = (target_position - global_position).normalized()
	var distance_to_target = global_position.distance_to(target_position)
	
	if distance_to_target > approach_distance:
		if not is_moving:
			is_moving = true
			movement_started.emit()
			print(npc_name + ": начинаю движение")
		
		velocity = direction * move_speed
		move_and_slide()
		
		# Поворачиваем спрайт в направлении движения
		if sprite:
			if direction.x > 0:
				sprite.flip_h = false
			elif direction.x < 0:
				sprite.flip_h = true
	else:
		if is_moving:
			is_moving = false
			is_at_target = true
			velocity = Vector2.ZERO
			movement_stopped.emit()
			target_reached.emit()
			print(npc_name + ": достиг цели")
			
			# Автоматически начинаем диалог
			if not dialogue_started and not dialogue_completed:
				start_auto_dialogue()

func start_auto_dialogue():
	"""Начать диалог автоматически при достижении цели"""
	dialogue_started = true
	print(npc_name + ": начинаю диалог")
	
	# Ждем немного перед началом диалога
	await get_tree().create_timer(0.5).timeout
	
	talk_to_npc()

func start_approach():
	"""Начать приближение к цели"""
	if not should_approach:
		should_approach = true
		is_at_target = false
		dialogue_started = false
		dialogue_completed = false
		current_dialogue_step = 0
		print(npc_name + ": начинаю движение к цели")

func stop_approach():
	"""Остановить приближение"""
	should_approach = false
	is_moving = false
	velocity = Vector2.ZERO
	print(npc_name + ": останавливаюсь")

# === ФУНКЦИИ ДЛЯ УПРАВЛЕНИЯ ИЗВНЕ ===
func set_target_position(pos: Vector2):
	"""Установить новую целевую позицию"""
	target_position = pos
	is_at_target = false
	dialogue_started = false
	dialogue_completed = false
	current_dialogue_step = 0
	print(npc_name + ": новая цель установлена - ", pos)

func set_approach_state(approach: bool):
	"""Включить/выключить режим приближения"""
	if approach:
		start_approach()
	else:
		stop_approach()

func reset_dialogue():
	"""Сбросить диалог для нового взаимодействия"""
	dialogue_started = false
	dialogue_completed = false
	current_dialogue_step = 0
	if Global != null:
		Global.hide_dialog()

# === СИГНАЛЫ ВЗАИМОДЕЙСТВИЯ ===
func _on_interaction_area_body_entered(body):
	if body.is_in_group("player"):
		player_in_range = true
		current_player = body
		print(npc_name + ": игрок рядом")
		
		# Если NPC не двигается к цели, показываем подсказку
		if not should_approach and not is_moving and not dialogue_completed:
			if Global != null:
				Global.show_interaction_prompt("Нажмите E чтобы начать разговор")

func _on_interaction_area_body_exited(body):
	if body.is_in_group("player"):
		player_in_range = false
		current_player = null
		print(npc_name + ": игрок ушел")
		
		# Скрываем подсказку
		if Global != null:
			Global.hide_interaction_prompt()

# === ОСНОВНАЯ ФУНКЦИЯ ДИАЛОГА ===
func talk_to_npc():
	if dialogue_completed:
		# Диалог уже завершен
		if Global != null:
			Global.show_message("Разговор уже закончен", 2.0)
		return
	
	dialogue_started = true
	current_dialogue_step = 0
	show_dialogue_step()

func continue_dialogue():
	if dialogue_completed:
		return
	
	current_dialogue_step += 1
	show_dialogue_step()

func show_dialogue_step():
	match current_dialogue_step:
		0:
			# СЕРГЕЙ: Господи... Ты здесь вообще живой?
			show_dialog_line("Господи... Ты здесь вообще живой?", "СЕРГЕЙ")
		1:
			# ВИКТОР: Давно не виделись... сколько? Пару лет точно прошло.
			show_dialog_line("Давно не виделись... сколько? Пару лет точно прошло.", "ВИКТОР")
		2:
			# СЕРГЕЙ: Да, действительно давно. Я пришёл не просто поболтать, я по делу. "Скульптор" вернулся.
			show_dialog_line("Да, действительно давно. Я пришёл не просто поболтать, я по делу. \"Скульптор\" вернулся.", "СЕРГЕЙ")
		3:
			# ВИКТОР (голос становится плоским, металлическим): Уходи. Сейчас же.
			show_dialog_line("Уходи. Сейчас же.", "ВИКТОР", "(голос становится плоским, металлическим)")
		4:
			# СЕРГЕЙ: Появились новые жертвы. Это его почерк.
			show_dialog_line("Появились новые жертвы. Это его почерк.", "СЕРГЕЙ")
		5:
			# ВИКТОР (трясясь): Я сказал уходи. Я не хочу больше НИЧЕГО слышать. На этом разговор закончен!
			show_dialog_line("Я сказал уходи. Я не хочу больше НИЧЕГО слышать. На этом разговор закончен!", "ВИКТОР", "(трясясь)")
		6:
			# СЕРГЕЙ: Помнишь Елену? Она стала его жертвой. Ты же помнишь как её семья к нам относилась. Подумай хорошенько, будут ещё жертвы, думаешь Макс бы простил тебя за самобичевание после провала? Ты нужен нам.
			show_dialog_line("Помнишь Елену? Она стала его жертвой. Ты же помнишь как её семья к нам относилась. Подумай хорошенько, будут ещё жертвы, думаешь Макс бы простил тебя за самобичевание после провала? Ты нужен нам.", "СЕРГЕЙ")
		7:
			# ВИКТОР (взрывается, хрипло): Я же сказал хватит!... Его больше нет! И никогда не будет! Всё, что осталось — это тишина в квартире и ничего более.
			show_dialog_line("Я же сказал хватит!... Его больше нет! И никогда не будет! Всё, что осталось — это тишина в квартире и ничего более.", "ВИКТОР", "(взрывается, хрипло)")
		8:
			# СЕРГЕЙ (спокойно, но твёрдо): Именно. Максима больше нет. А этот маньяк - есть. И он продолжает работать. Сегодня бал-маскарад у Вольского. По слухам, там будут представлены те самые... экспонаты, а ты знаешь, как думает «Скульптор». Ты вёл его первое дело.
			show_dialog_line("Именно. Максима больше нет. А этот маньяк - есть. И он продолжает работать. Сегодня бал-маскарад у Вольского. По слухам, там будут представлены те самые... экспонаты, а ты знаешь, как думает «Скульптор». Ты вёл его первое дело.", "СЕРГЕЙ", "(спокойно, но твёрдо)")
		9:
			# ВИКТОР: …
			show_dialog_line("…", "ВИКТОР", "(пауза)")
			# Автоматически переходим к следующему шагу через небольшую паузу
			await get_tree().create_timer(2.0).timeout
			current_dialogue_step += 1
			show_dialogue_step()
		10:
			# ВИКТОР (чуть слышно): Хорошо… Только потому что ты просишь. Что я должен искать?
			show_dialog_line("Хорошо… Только потому что ты просишь. Что я должен искать?", "ВИКТОР", "(чуть слышно)")
		11:
			# ВИКТОР (чуть слышно): Хорошо… Только потому что ты просишь. Что я должен искать?
			show_dialog_line("Любую связь. Кто покупает. Кто продаёт. Кто слишком интересуется. Вольский, его окружение. Дай сигнал — мы будем снаружи. Это твой шанс, Виктор. Приводи себя в порядок, а я буду ждать внизу.", "СЕРГЕЙ")
		12:
			# СЕРГЕЙ: Любую связь. Кто покупает. Кто продаёт. Кто слишком интересуется. Вольский, его окружение. Дай сигнал — мы будем снаружи. Это твой шанс, Виктор. Приводи себя в порядок, а я буду ждать внизу.
			show_dialog_line("Любую связь. Кто покупает. Кто продаёт. Кто слишком интересуется. Вольский, его окружение. Дай сигнал — мы будем снаружи. Это твой шанс, Виктор. Приводи себя в порядок, а я буду ждать внизу.", "СЕРГЕЙ")

		13:
			# СЕРГЕЙ: Любую связь. Кто покупает. Кто продаёт. Кто слишком интересуется. Вольский, его окружение. Дай сигнал — мы будем снаружи. Это твой шанс, Виктор. Приводи себя в порядок, а я буду ждать внизу.
			show_dialog_line("Любую связь. Кто покупает. Кто продаёт. Кто слишком интересуется. Вольский, его окружение. Это твой шанс, Виктор. Приводи себя в порядок, а я буду ждать в особняке.", "СЕРГЕЙ")
			# Завершаем диалог
			dialogue_completed = true
			_on_dialogue_completed()
		_:
			# Если шаг больше максимального, завершаем диалог
			if current_dialogue_step > 11:
				dialogue_completed = true
				_on_dialogue_completed()

func show_dialog_line(text: String, speaker: String, emotion: String = ""):
	var full_text = speaker
	if emotion != "":
		full_text += " " + emotion
	full_text += ": " + text
	
	print(full_text)  # Для отладки
	
	if Global != null:
		# Создаем опции для продолжения диалога
		var options = [
			{
				"text": "Продолжить",
				"callback": Callable(self, "continue_dialogue")
			}
		]
		Global.show_dialog(full_text, options)
	else:
		# Если Global нет, просто выводим в консоль
		print("=== ДИАЛОГ ===")
		print(full_text)
		print("===============")

func _on_dialogue_completed():
	print("Диалог завершен")
	dialogue_started = false
	
	# Скрываем диалог, если есть Global
	if Global != null:
		Global.hide_dialog()
		Global.show_message("Разговор закончен", 2.0)
	
	# После диалога можно добавить логику ухода NPC
	# Например, Сергей может уйти в другую точку
	# start_leaving()

# === ДОПОЛНИТЕЛЬНЫЕ ФУНКЦИИ ===
func get_npc_info() -> Dictionary:
	"""Получить информацию об NPC"""
	return {
		"name": npc_name,
		"position": global_position,
		"target": target_position,
		"dialogue_completed": dialogue_completed,
		"is_moving": is_moving
	}

func debug_npc():
	"""Отладочная информация"""
	print("=== NPC DEBUG ===")
	print("Имя:", npc_name)
	print("Позиция:", global_position)
	print("Цель:", target_position)
	print("Двигается:", is_moving)
	print("Достиг цели:", is_at_target)
	print("Диалог начат:", dialogue_started)
	print("Диалог завершен:", dialogue_completed)
	print("Шаг диалога:", current_dialogue_step)
	print("=================")
