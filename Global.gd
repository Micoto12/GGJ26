extends Node

static var instance

var inventory_hud: CanvasLayer
var dialog
var interaction_prompt
var message_label: Label
var message_timer: Timer

# Диалоговая система
var current_dialog_title: String = ""
var dialog_buttons_container: VBoxContainer
var dialog_panel: Panel
var dialog_label: Label

func _ready():
	instance = self
	create_interaction_prompt()
	create_message_label.call_deferred()
	create_hud_inventory.call_deferred()
	create_dialog.call_deferred()


func create_hud_inventory():
	print("Создаю HUD инвентарь...")
	
	var hud_scene = load("res://scene/InventoryHUD.tscn")
	if hud_scene:
		var inventory_instance = hud_scene.instantiate()
		
		if inventory_instance is CanvasLayer:
			inventory_hud = inventory_instance
			inventory_hud.name = "InventoryHUD"
			
			# Устанавливаем позицию
			var hbox = inventory_hud.get_node("HBoxContainer")
			if hbox:
				var viewport_size = get_viewport().size
				hbox.position = Vector2(20, viewport_size.y - 100)
			
			# Делаем видимым
			inventory_hud.show()
			
			# Добавляем в корень сцены с задержкой
			get_tree().root.call_deferred("add_child", inventory_hud)
			print("✓ HUD инвентарь (CanvasLayer) создан и показан")
		else:
			print("✗ Загруженная сцена не является CanvasLayer")
			create_simple_hud_inventory()
	else:
		print("✗ Не удалось загрузить HUD инвентарь")
		create_simple_hud_inventory()

func create_simple_hud_inventory():
	print("Создаю простой HUD инвентарь через код...")
	
	inventory_hud = CanvasLayer.new()
	inventory_hud.name = "InventoryHUD"
	inventory_hud.layer = 5
	inventory_hud.visible = true
	
	# Контейнер для слотов
	var container = HBoxContainer.new()
	container.name = "HBoxContainer"
	
	# Позиция внизу слева
	var viewport_size = get_viewport().size
	container.position = Vector2(20, viewport_size.y - 100)
	container.set("theme_override_constants/separation", 10)
	
	# Создаем 4 слота
	for i in range(4):
		var slot = Panel.new()
		slot.name = "Slot" + str(i+1)
		slot.custom_minimum_size = Vector2(64, 64)
		
		# Стиль слота
		var style = StyleBoxFlat.new()
		style.bg_color = Color(0.1, 0.1, 0.3, 0.9)
		style.border_color = Color(1, 1, 1)
		style.border_width_left = 2
		style.border_width_right = 2
		style.border_width_top = 2
		style.border_width_bottom = 2
		slot.add_theme_stylebox_override("panel", style)
		
		# Иконка предмета (ВАЖНО: добавляем именно с именем "Icon")
		var icon = TextureRect.new()
		icon.name = "Icon"  # Это важно!
		icon.position = Vector2(4, 4)
		icon.size = Vector2(56, 56)
		icon.hide()
		
		# Количество (ВАЖНО: добавляем именно с именем "Count")
		var count = Label.new()
		count.name = "Count"  # Это важно!
		count.position = Vector2(40, 40)
		count.size = Vector2(20, 20)
		count.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		count.add_theme_font_size_override("font_size", 14)
		count.add_theme_color_override("font_color", Color(1, 1, 0))
		count.hide()
		
		slot.add_child(icon)
		slot.add_child(count)
		container.add_child(slot)
	
	inventory_hud.add_child(container)
	get_tree().root.call_deferred("add_child", inventory_hud)
	
	print("✓ Простой HUD инвентарь создан и показан")
	print("Структура HUD инвентаря:")
	print("- CanvasLayer (inventory_hud)")
	print("  - HBoxContainer")
	for i in range(4):
		print("    - Slot" + str(i+1))
		print("      - Icon (TextureRect)")
		print("      - Count (Label)")
		


func print_structure(node, depth):
	var indent = ""
	for i in range(depth):
		indent += "  "
	
	print(indent + "├─ " + node.name + " (" + node.get_class() + ")")
	
	for i in range(node.get_child_count()):
		var child = node.get_child(i)
		print_structure(child, depth + 1)
# Создаем универсальное диалоговое окно с динамическими кнопками
func create_dialog():
	print("Создаю универсальное диалоговое окно...")
	
	dialog = CanvasLayer.new()
	dialog.name = "Dialog"
	dialog.layer = 200
	
	# Панель диалога
	dialog_panel = Panel.new()
	dialog_panel.name = "Panel"
	
	# Размер и позиция панели (внизу по центру)
	var viewport_size = get_viewport().size
	dialog_panel.size = Vector2(650, 280)
	dialog_panel.position = Vector2(
		(viewport_size.x - 650) / 2,
		viewport_size.y - 320  # 280 + отступ 40 от нижнего края
	)
	
	# Стиль панели
	var panel_style = StyleBoxFlat.new()
	panel_style.bg_color = Color(0.15, 0.15, 0.25, 0.95)
	panel_style.border_color = Color(0.2, 0.8, 0.8)
	panel_style.border_width_left = 3
	panel_style.border_width_right = 3
	panel_style.border_width_top = 3
	panel_style.border_width_bottom = 3
	panel_style.corner_radius_top_left = 15
	panel_style.corner_radius_top_right = 15
	panel_style.corner_radius_bottom_left = 15
	panel_style.corner_radius_bottom_right = 15
	
	dialog_panel.add_theme_stylebox_override("panel", panel_style)
	
	# Заголовок диалога
	var title_label = Label.new()
	title_label.name = "TitleLabel"
	title_label.position = Vector2(20, 15)
	title_label.size = Vector2(610, 30)
	title_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	title_label.add_theme_font_size_override("font_size", 24)
	title_label.add_theme_color_override("font_color", Color(0.8, 0.9, 1.0))
	title_label.text = "Диалог"
	dialog_panel.add_child(title_label)
	
	# Текст диалога (реплика NPC или описание)
	dialog_label = Label.new()
	dialog_label.name = "DialogLabel"
	dialog_label.position = Vector2(30, 60)
	dialog_label.size = Vector2(590, 80)
	dialog_label.vertical_alignment = VERTICAL_ALIGNMENT_TOP
	dialog_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	dialog_label.add_theme_font_size_override("font_size", 20)
	dialog_label.add_theme_color_override("font_color", Color(1, 1, 1))
	dialog_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	dialog_panel.add_child(dialog_label)
	
	# Контейнер для кнопок (вертикальное расположение)
	dialog_buttons_container = VBoxContainer.new()
	dialog_buttons_container.name = "ButtonsContainer"
	dialog_buttons_container.position = Vector2(30, 150)
	dialog_buttons_container.size = Vector2(590, 110)
	dialog_buttons_container.set("theme_override_constants/separation", 8)
	dialog_panel.add_child(dialog_buttons_container)
	
	dialog.add_child(dialog_panel)
	get_tree().root.call_deferred("add_child", dialog)
	
	# Скрываем диалог при создании
	dialog.hide()
	
	print("✓ Универсальное диалоговое окно создано (скрыто)")

# Очистить все кнопки диалога
func clear_dialog_buttons():
	if dialog_buttons_container:
		for child in dialog_buttons_container.get_children():
			child.queue_free()

# Создать кнопку диалога
func create_dialog_button(button_text: String, callback: Callable = Callable()):
	var button = Button.new()
	button.text = button_text
	button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	button.custom_minimum_size = Vector2(0, 40)
	button.focus_mode = Control.FOCUS_ALL
	
	# Стиль кнопки
	var button_style = StyleBoxFlat.new()
	button_style.bg_color = Color(0.2, 0.3, 0.6)
	button_style.border_color = Color(0.4, 0.6, 0.9)
	button_style.border_width_left = 2
	button_style.border_width_right = 2
	button_style.border_width_top = 2
	button_style.border_width_bottom = 2
	button_style.corner_radius_top_left = 6
	button_style.corner_radius_top_right = 6
	button_style.corner_radius_bottom_left = 6
	button_style.corner_radius_bottom_right = 6
	
	button.add_theme_stylebox_override("normal", button_style)
	button.add_theme_font_size_override("font_size", 18)
	button.add_theme_color_override("font_color", Color(1, 1, 1))
	
	# Эффект при наведении
	var button_hover = button_style.duplicate()
	button_hover.bg_color = Color(0.3, 0.4, 0.7)
	button.add_theme_stylebox_override("hover", button_hover)
	
	# Эффект при нажатии
	var button_pressed = button_style.duplicate()
	button_pressed.bg_color = Color(0.1, 0.2, 0.5)
	button.add_theme_stylebox_override("pressed", button_pressed)
	
	# Подключаем обработчик
	if callback.is_valid():
		button.pressed.connect(callback)
	else:
		button.pressed.connect(_on_close_dialog)
	
	# Подключаем автоматическое закрытие после выбора
	button.pressed.connect(_on_dialog_option_selected)
	
	return button

# Показать диалог с динамическими кнопками
static func show_dialog(title: String = "", message: String = "", options: Array = []):
	if not instance or not instance.dialog:
		print("ОШИБКА: Диалог не создан")
		return
	
	# Устанавливаем заголовок и сообщение
	if instance.dialog_panel:
		var title_label = instance.dialog_panel.get_node("TitleLabel")
		if title_label:
			title_label.text = title if title != "" else "Диалог"
	
	if instance.dialog_label:
		instance.dialog_label.text = message
	
	# Очищаем старые кнопки
	instance.clear_dialog_buttons()
	
	# Если опций нет, добавляем кнопку "Закрыть"
	if options.size() == 0:
		options.append({"text": "Закрыть", "action": "close"})
	
	# Создаем кнопки для каждой опции
	for option in options:
		var button_text = option.get("text", "???")
		var action = option.get("action", "")
		var callback = option.get("callback", Callable())
		var next_dialog = option.get("next_dialog", null)
		
		# Создаем колбэк для кнопки
		var button_callback: Callable
		
		if callback.is_valid():
			# Если передан явный колбэк
			button_callback = callback
		elif action == "close":
			# Закрыть диалог
			button_callback = instance._on_close_dialog
		elif action == "take_item" and "item" in option:
			# Взять предмет
			button_callback = func():
				var item_name = option["item"]
				var texture = option.get("texture", "")
				var count = option.get("count", 1)
				instance._on_take_item_dialog(item_name, texture, count)
		elif next_dialog is Array:
			# Показать следующий диалог
			button_callback = func():
				Global.show_dialog(
					next_dialog.get("title", ""),
					next_dialog.get("message", ""),
					next_dialog.get("options", [])
				)
		else:
			# По умолчанию закрываем диалог
			button_callback = instance._on_close_dialog
		
		# Создаем и добавляем кнопку
		var button = instance.create_dialog_button(button_text, button_callback)
		instance.dialog_buttons_container.add_child(button)
	
	# Показываем диалог
	instance.dialog.show()
	print("Диалог показан:", title)

# Старая функция для совместимости (показать диалог с предметом)
# Показать диалог для взятия предмета (сохраняем для обратной совместимости)
static func show_item_dialog(item_name: String, description: String = ""):
	if not instance or not instance.dialog:
		print("ОШИБКА: Диалог не создан")
		return
	
	# Создаем текст диалога
	var dialog_text = "Вы нашли: " + item_name
	if description != "":
		dialog_text += "\n\n" + description
	dialog_text += "\n\nВзять предмет?"
	
	# Получаем путь к текстуре
	var texture_path = instance.get_item_texture(item_name)
	
	# Создаем callback функцию для кнопки "Взять"
	var take_callback = func():
		print("Выбрано: Взять предмет")
		var success = Global.add_to_hud(item_name, texture_path, 1)
		if success:
			print("Предмет добавлен в инвентарь:", item_name)
			instance.show_message("Получен: " + item_name)
		else:
			print("Не удалось добавить предмет в инвентарь")
			instance.show_message("Не удалось взять предмет", 3.0)
		# Закрываем диалог после выбора
		instance.dialog.hide()
	
	# Показываем диалог
	show_dialog(
		"Найден предмет",
		dialog_text,
		[
			{
				"text": "Взять",
				"callback": take_callback
			},
			{
				"text": "Оставить",
				"action": "close"
			}
		]
	)
# Обработчик взятия предмета через диалог
func _on_take_item_dialog(item_name: String, texture_path: String = "", count: int = 1):
	print("Берём предмет из диалога:", item_name)
	
	var success = add_to_hud(item_name, texture_path, count)
	
	if success:
		show_message("Получен: " + item_name)
		print("Предмет добавлен в инвентарь:", item_name)
	else:
		print("Не удалось добавить предмет в инвентарь:", item_name)
		show_message("Не удалось добавить предмет в инвентарь", 2.0)
	
	dialog.hide()

# Обработчик закрытия диалога
func _on_close_dialog():
	print("Диалог закрыт")
	dialog.hide()

# Обработчик выбора опции диалога
func _on_dialog_option_selected():
	print("Опция диалога выбрана")
	# Здесь можно добавить дополнительные действия при выборе опции

# Функция для добавления предмета в HUD инвентарь
static func add_to_hud(item_name: String, texture_path: String = "", count: int = 1) -> bool:
	if not instance or not instance.inventory_hud:
		print("ОШИБКА: HUD инвентарь не создан")
		return false
	
	print("Добавляем предмет в инвентарь:", item_name)
	print("Путь к текстуре:", texture_path)
	print("Количество:", count)
	
	# Загружаем текстуру если указан путь
	var texture = null
	if texture_path != "":
		texture = load(texture_path)
		print("Текстура загружена:", texture != null)
	
	# Проверяем тип инвентаря
	if instance.inventory_hud is CanvasLayer:
		print("Тип инвентаря: CanvasLayer")
		
		# Пытаемся найти HBoxContainer внутри CanvasLayer
		var hbox = null
		
		# Сначала ищем рекурсивно
		hbox = instance.inventory_hud.find_child("HBoxContainer", true, false)
		
		if not hbox:
			# Если не нашли рекурсивно, ищем среди детей
			for child in instance.inventory_hud.get_children():
				if child is HBoxContainer:
					hbox = child
					break
		
		if hbox:
			print("Найден HBoxContainer в инвентаре")
			print("Количество слотов в HBoxContainer:", hbox.get_child_count())
			return add_item_to_simple_hud(item_name, texture, count, hbox)
		else:
			print("ОШИБКА: HBoxContainer не найден в инвентаре!")
			print("Дети CanvasLayer:")
			for child in instance.inventory_hud.get_children():
				print("  -", child.name, " (", child.get_class(), ")")
			return false
	else:
		print("Неизвестный тип инвентаря:", instance.inventory_hud.get_class())
		return false

# Добавление предмета в простой HUD инвентарь
static func add_item_to_simple_hud(item_name: String, texture: Texture, count: int, hbox: HBoxContainer) -> bool:
	print("Добавляем предмет в простой HUD инвентарь")
	
	# Ищем пустой слот или слот с таким же предметом
	for i in range(hbox.get_child_count()):
		var slot = hbox.get_child(i)
		print("Проверяем слот", i, ":", slot.name)
		
		# Ищем иконку в слоте
		var icon = null
		for child in slot.get_children():
			if child.name == "Icon" or child is TextureRect:
				icon = child
				break
		
		if icon:
			print("Найдена иконка в слоте", i, ":", icon.visible)
			
			# Если иконка скрыта (пустой слот)
			if not icon.visible:
				print("Нашли пустой слот", i)
				
				# Устанавливаем текстуру
				if texture:
					icon.texture = texture
				icon.show()
				
				# Ищем лейбл для количества
				var count_label = null
				for child in slot.get_children():
					if child.name == "Count" or child is Label:
						count_label = child
						break
				
				if count_label:
					if count > 1:
						count_label.text = str(count)
						count_label.show()
					else:
						count_label.text = ""
						count_label.hide()
				
				print("✓ Предмет добавлен в слот", i+1)
				return true
		else:
			print("Иконка не найдена в слоте", i)
	
	print("✗ Нет свободных слотов")
	return false

# Получить текстуру предмета по имени
func get_item_texture(item_name: String) -> String:
	match item_name:
		"Золотая монета":
			return "res://assets/coin.png"
		"Ключ":
			return "res://assets/player.png"
		"Зелье здоровья":
			return "res://assets/tileset.png"
		_:
			return ""

func create_interaction_prompt():
	# Создаём CanvasLayer для UI
	var canvas = CanvasLayer.new()
	canvas.layer = 10
	add_child(canvas)
	
	# Создаём панель подсказки
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

func create_message_label():
	# Создаем CanvasLayer для сообщений
	var canvas = CanvasLayer.new()
	canvas.layer = 20
	add_child(canvas)
	
	# Создаем панель сообщения
	message_label = Label.new()
	message_label.text = ""
	message_label.size = Vector2(400, 100)
	message_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	message_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	
	# Красивый стиль текста
	message_label.add_theme_font_size_override("font_size", 36)
	message_label.add_theme_color_override("font_color", Color(1, 1, 0))
	message_label.add_theme_constant_override("outline_size", 4)
	message_label.add_theme_color_override("font_outline_color", Color(0, 0, 0))
	
	canvas.add_child(message_label)
	message_label.hide()
	
	# Создаем таймер для автоскрытия
	message_timer = Timer.new()
	add_child(message_timer)
	message_timer.timeout.connect(_on_message_timeout)

func show_interaction_prompt(text: String):
	if interaction_prompt:
		interaction_prompt.get_child(0).text = text
		var viewport_size = get_viewport().size
		interaction_prompt.position = Vector2(
			(viewport_size.x - 200) / 2,
			viewport_size.y * 0.7
		)
		interaction_prompt.show()

func hide_interaction_prompt():
	if interaction_prompt:
		interaction_prompt.hide()

func show_message(text: String, duration: float = 2.0):
	if message_label:
		message_label.text = text
		var viewport_size = get_viewport().size
		message_label.position = Vector2(
			(viewport_size.x - 400) / 2,
			(viewport_size.y - 100) / 2
		)
		message_label.show()
		message_timer.start(duration)

func _on_message_timeout():
	if message_label:
		message_label.hide()
