extends Node

# Статическая переменная для доступа из любого места
static var instance

# Ссылка на подсказку
var interaction_prompt
# Добавьте эти переменные в начало файла
var message_label: Label
var message_timer: Timer

func _ready():
	instance = self
	create_interaction_prompt()

	instance = self
	create_interaction_prompt()
	create_message_label()  # <-- Добавить эту строку

func create_interaction_prompt():
	# Создаем CanvasLayer для UI
	var canvas = CanvasLayer.new()
	canvas.layer = 10  # Высокий слой
	add_child(canvas)
	
	# Создаем панель подсказки
	interaction_prompt = Panel.new()
	interaction_prompt.size = Vector2(200, 60)
	canvas.add_child(interaction_prompt)
	
	# Добавляем текст
	var label = Label.new()
	label.text = ""
	label.size = Vector2(200, 60)
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	interaction_prompt.add_child(label)
	
	# Прячем по умолчанию
	interaction_prompt.hide()

func show_interaction_prompt(text: String):
	if interaction_prompt:
		# Обновляем текст
		interaction_prompt.get_child(0).text = text
		
		# Центрируем на экране
		var viewport_size = get_viewport().size
		interaction_prompt.position = Vector2(
			(viewport_size.x - 200) / 2,
			viewport_size.y * 0.7  # Внизу экрана
		)
		
		interaction_prompt.show()

func hide_interaction_prompt():
	if interaction_prompt:
		interaction_prompt.hide()
		
func create_message_label():
	# Создаем CanvasLayer для сообщений
	var canvas = CanvasLayer.new()
	canvas.layer = 20  # Выше чем подсказка
	add_child(canvas)
	
	# Создаем панель сообщения
	message_label = Label.new()
	message_label.text = ""
	message_label.size = Vector2(400, 100)
	message_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	message_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	
	# Красивый стиль текста
	message_label.add_theme_font_size_override("font_size", 36)
	message_label.add_theme_color_override("font_color", Color(1, 1, 0))  # Желтый
	message_label.add_theme_constant_override("outline_size", 4)
	message_label.add_theme_color_override("font_outline_color", Color(0, 0, 0))
	
	canvas.add_child(message_label)
	message_label.hide()
	
	# Создаем таймер для автоскрытия
	message_timer = Timer.new()
	add_child(message_timer)
	message_timer.timeout.connect(_on_message_timeout)

# Функция показа сообщения
func show_message(text: String, duration: float = 2.0):
	if message_label:
		message_label.text = text
		
		# Центрируем на экране
		var viewport_size = get_viewport().size
		message_label.position = Vector2(
			(viewport_size.x - 400) / 2,
			(viewport_size.y - 100) / 2
		)
		
		message_label.show()
		
		# Автоскрытие через duration секунд
		message_timer.start(duration)

func _on_message_timeout():
	if message_label:
		message_label.hide()
