extends Node

static var instance

var inventory_hud: CanvasLayer
var dialog
var interaction_prompt
var message_label: Label
var message_timer: Timer

# Диалоговая система
var dialog_panel: Panel
var dialog_label: Label
var dialog_buttons_container: VBoxContainer
var current_dialog_options: Array = []

# Переменные для отслеживания размеров окна
var last_window_size: Vector2
var fullscreen_enabled: bool = true

func _ready():
	instance = self
	randomize()  # Инициализация генератора случайных чисел
<<<<<<< HEAD
	
	# Настраиваем окно ПЕРВЫМ ДЕЛОМ!
	setup_window()
	
=======
	# Настраиваем окно ПЕРВЫМ ДЕЛОМ!
	setup_window()
>>>>>>> d1c9d18e51db28b1e8f627694d89f10d3ca43c4a
	# Создаем элементы UI
	create_interaction_prompt()
	create_message_label.call_deferred()
	create_hud_inventory.call_deferred()
	create_dialog.call_deferred()
<<<<<<< HEAD
	
	# Подписываемся на изменение размера окна
	get_tree().root.size_changed.connect(_on_window_resized)
	print("Global.gd инициализирован, режим окна: ", "Полноэкранный" if fullscreen_enabled else "Оконный")
=======
	# 🔊 АВТО-SFX ДЛЯ КНОПОК
	get_tree().node_added.connect(_on_node_added)

	# Подписываемся на изменение размера окна
	get_tree().root.size_changed.connect(_on_window_resized)
	print("Global.gd инициализирован, режим окна: ", "Полноэкранный" if fullscreen_enabled else "Оконный")
func _on_node_added(node: Node):
	if node is Button:
		_attach_sfx_to_button(node)
func _attach_sfx_to_button(button: Button):
	# Нажатие
	if not button.pressed.is_connected(_on_button_pressed):
		button.pressed.connect(_on_button_pressed)

	# Наведение
	if not button.mouse_entered.is_connected(_on_button_hover):
		button.mouse_entered.connect(_on_button_hover)
func _on_button_pressed():
	if Music:
		Music.play_sfx("click")

func _on_button_hover():
	if Music:
		Music.play_sfx("hover")
>>>>>>> d1c9d18e51db28b1e8f627694d89f10d3ca43c4a

func setup_window():
	# Получаем главное окно
	var window = get_window()
	
	# Устанавливаем полноэкранный режим
	window.mode = Window.MODE_FULLSCREEN
	fullscreen_enabled = true
	
	# Устанавливаем минимальный размер для оконного режима
	window.min_size = Vector2(1024, 600)
	
	# Устанавливаем заголовок окна
	window.title = "Моя RPG Игра"
	
	# Включаем вертикальную синхронизацию для плавности
	DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
	
	# Сохраняем текущий размер окна
	last_window_size = window.size
	print("Размер окна установлен: ", last_window_size)

func _on_window_resized():
	# Обновляем размеры UI элементов при изменении размера окна
	var current_size = get_window().size
	
	if current_size != last_window_size:
		print("Размер окна изменился: ", current_size)
		last_window_size = current_size
		
		# Обновляем позиции всех UI элементов
		update_ui_positions()

func update_ui_positions():
	if interaction_prompt:
		# Обновляем позицию подсказки взаимодействия
		var prompt_label = interaction_prompt.get_child(0) if interaction_prompt.get_child_count() > 0 else null
		if prompt_label and prompt_label.text != "":
			show_interaction_prompt(prompt_label.text)
	
	if message_label and message_label.visible:
		# Обновляем позицию сообщения
		show_message(message_label.text, message_timer.time_left)
	
	if dialog and dialog.visible:
		# Обновляем позицию диалога
		update_dialog_position()
	
	if inventory_hud:
		# Обновляем позицию инвентаря
		update_inventory_position()

func update_inventory_position():
	var viewport_size = get_viewport().size
	
	if inventory_hud:
		var hbox = inventory_hud.get_node_or_null("HBoxContainer")
		if hbox:
			# Размещаем инвентарь внизу слева с отступами
			var margin = 20
			hbox.position = Vector2(margin, viewport_size.y - hbox.size.y - margin)
		else:
			# Ищем HBoxContainer среди всех детей
			for child in inventory_hud.get_children():
				if child is HBoxContainer:
					child.position = Vector2(20, viewport_size.y - child.size.y - 20)
					break

func update_dialog_position():
	if dialog_panel:
		var viewport_size = get_viewport().size
		# Размещаем диалог по центру снизу с адаптивными отступами
		var margin_bottom = 40
		var dialog_height = dialog_panel.size.y
		dialog_panel.position = Vector2(
			(viewport_size.x - dialog_panel.size.x) / 2,
			viewport_size.y - dialog_height - margin_bottom
		)

func toggle_fullscreen():
	var window = get_window()
	
	if fullscreen_enabled:
		# Переключаем в оконный режим
		window.mode = Window.MODE_WINDOWED
		window.size = Vector2(1280, 720)  # Устанавливаем комфортный размер
		window.position = (DisplayServer.screen_get_size() - window.size) / 2  # Центрируем
		fullscreen_enabled = false
		print("Переключено в оконный режим")
	else:
		# Переключаем в полноэкранный режим
		window.mode = Window.MODE_FULLSCREEN
		fullscreen_enabled = true
		print("Переключено в полноэкранный режим")
	
	# Обновляем UI
	update_ui_positions()

func create_hud_inventory():
	print("Создаю HUD инвентарь...")
	
	var hud_scene = load("res://scene/InventoryHUD.tscn")
	if hud_scene:
		var inventory_instance = hud_scene.instantiate()
		
		if inventory_instance is CanvasLayer:
			inventory_hud = inventory_instance
			inventory_hud.name = "InventoryHUD"
			
			# Делаем видимым
			inventory_hud.show()
			
			# Добавляем в корень сцены с задержкой
			get_tree().root.call_deferred("add_child", inventory_hud)
			print("✓ HUD инвентарь (CanvasLayer) создан и показан")
			
			# Обновляем позицию
			update_inventory_position.call_deferred()
			
			# Инициализируем связь между Global и InventoryHUD
			if inventory_hud.has_method("set_global_reference"):
				inventory_hud.set_global_reference(self)
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
	
	# Устанавливаем стиль контейнера
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
		
		# Иконка предмета
		var icon = TextureRect.new()
		icon.name = "Icon"
		icon.position = Vector2(4, 4)
		icon.size = Vector2(56, 56)
		icon.hide()
		
		# Количество
		var count = Label.new()
		count.name = "Count"
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
	
	# Обновляем позицию
	update_inventory_position.call_deferred()

func create_dialog():
	print("Создаю универсальное диалоговое окно...")
	
	dialog = CanvasLayer.new()
	dialog.name = "Dialog"
	dialog.layer = 200
	
	# Панель диалога
	dialog_panel = Panel.new()
	dialog_panel.name = "Panel"
	
	# Размер и позиция панели (внизу по центру)
	dialog_panel.size = Vector2(700, 300)
	
	# Стиль панели
	var panel_style = StyleBoxFlat.new()
	panel_style.bg_color = Color(0.12, 0.12, 0.2, 0.98)
	panel_style.border_color = Color(0.3, 0.7, 0.9)
	panel_style.border_width_left = 4
	panel_style.border_width_right = 4
	panel_style.border_width_top = 4
	panel_style.border_width_bottom = 4
	panel_style.corner_radius_top_left = 20
	panel_style.corner_radius_top_right = 20
	panel_style.corner_radius_bottom_left = 20
	panel_style.corner_radius_bottom_right = 20
	
	dialog_panel.add_theme_stylebox_override("panel", panel_style)
	
	# Текст диалога
	dialog_label = Label.new()
	dialog_label.name = "DialogLabel"
	dialog_label.position = Vector2(40, 30)
	dialog_label.size = Vector2(620, 140)
	dialog_label.vertical_alignment = VERTICAL_ALIGNMENT_TOP
	dialog_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	dialog_label.add_theme_font_size_override("font_size", 24)
	dialog_label.add_theme_color_override("font_color", Color(0.9, 0.9, 1.0))
	dialog_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	dialog_panel.add_child(dialog_label)
	
	# Контейнер для кнопок ответов
	dialog_buttons_container = VBoxContainer.new()
	dialog_buttons_container.name = "ButtonsContainer"
	dialog_buttons_container.position = Vector2(40, 180)
	dialog_buttons_container.size = Vector2(620, 100)
	dialog_buttons_container.set("theme_override_constants/separation", 10)
	dialog_panel.add_child(dialog_buttons_container)
	
	dialog.add_child(dialog_panel)
	get_tree().root.call_deferred("add_child", dialog)
	
	# Скрываем диалог при создании
	dialog.hide()
	
	print("✓ Универсальное диалоговое окно создано (скрыто)")
	
	# Обновляем позицию
	update_dialog_position.call_deferred()

# Очистить все кнопки диалога
func clear_dialog_buttons():
	if dialog_buttons_container:
		for child in dialog_buttons_container.get_children():
			child.queue_free()
	current_dialog_options.clear()

# Создать кнопку диалога
func create_dialog_button(button_text: String, callback: Callable = Callable()) -> Button:
	var button = Button.new()
	button.text = button_text
	button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	button.custom_minimum_size = Vector2(0, 50)
	button.focus_mode = Control.FOCUS_ALL
	
	# Стиль кнопки
	var button_style = StyleBoxFlat.new()
	button_style.bg_color = Color(0.2, 0.4, 0.6)
	button_style.border_color = Color(0.4, 0.6, 0.9)
	button_style.border_width_left = 2
	button_style.border_width_right = 2
	button_style.border_width_top = 2
	button_style.border_width_bottom = 2
	button_style.corner_radius_top_left = 8
	button_style.corner_radius_top_right = 8
	button_style.corner_radius_bottom_left = 8
	button_style.corner_radius_bottom_right = 8
	
	button.add_theme_stylebox_override("normal", button_style)
	button.add_theme_font_size_override("font_size", 20)
	button.add_theme_color_override("font_color", Color(1, 1, 1))
	
	# Эффект при наведении
	var button_hover = button_style.duplicate()
	button_hover.bg_color = Color(0.3, 0.5, 0.7)
	button.add_theme_stylebox_override("hover", button_hover)
	
	# Эффект при нажатии
	var button_pressed = button_style.duplicate()
	button_pressed.bg_color = Color(0.1, 0.3, 0.5)
	button.add_theme_stylebox_override("pressed", button_pressed)
	
	# Подключаем обработчик
	if callback.is_valid():
		button.pressed.connect(func():
			callback.call()
			dialog.hide()  # Закрываем диалог после выбора
		)
	else:
		button.pressed.connect(func(): dialog.hide())
	
	return button

# УНИВЕРСАЛЬНАЯ ФУНКЦИЯ ДЛЯ ПОКАЗА ДИАЛОГА
static func show_dialog(dialog_text: String, options: Array = []):
	if not instance or not instance.dialog:
		print("ОШИБКА: Диалог не создан")
		return
	
	# Устанавливаем текст диалога
	if instance.dialog_label:
		instance.dialog_label.text = dialog_text
	
	# Очищаем старые кнопки
	instance.clear_dialog_buttons()
	
	# Если опций нет, добавляем кнопку "Закрыть"
	if options.size() == 0:
		options.append({
			"text": "Закрыть",
			"callback": Callable()
		})
	
	# Создаем кнопки для каждой опции
	for option in options:
		var button_text = option.get("text", "???")
		var callback = option.get("callback", Callable())
		var item_data = option.get("item_data", null)
		
		# Если есть данные предмета, создаем специальный колбэк
		if item_data and callback.is_null():
			callback = func():
				var item_name = item_data.get("name", "")
				var texture_path = item_data.get("texture", "")
				var count = item_data.get("count", 1)
				if item_name != "":
					var success = Global.add_to_hud(item_name, texture_path, count)
					if success:
						Global.show_message("Получено: " + item_name)
					else:
						Global.show_message("Не удалось взять предмет", 3.0)
		
		# Создаем и добавляем кнопку
		var button = instance.create_dialog_button(button_text, callback)
		instance.dialog_buttons_container.add_child(button)
	
	# Показываем диалог
	instance.dialog.show()
	print("Диалог показан")

# Функция для добавления предмета в HUD инвентарь
static func add_to_hud(item_name: String, texture_path: String = "", count: int = 1) -> bool:
	if not instance or not instance.inventory_hud:
		print("ОШИБКА: HUD инвентарь не создан")
		return false
	
	# Загружаем текстуру если указан путь
	var texture = null
	if texture_path != "":
		texture = load(texture_path)
		if texture == null:
			print("Не удалось загрузить текстуру: ", texture_path)
			# Используем дефолтную текстуру
			texture = load("res://assets/player.png")
	
	# Проверяем тип инвентаря
	if instance.inventory_hud is CanvasLayer:
		# Если у инвентаря есть метод add_item (InventoryHUD сцена)
		if instance.inventory_hud.has_method("add_item"):
			print("Добавляем предмет через метод add_item инвентаря: ", item_name, " x", count)
			return instance.inventory_hud.add_item(item_name, texture, count)
		else:
			# Ищем HBoxContainer в простом инвентаре
			var hbox = null
			hbox = instance.inventory_hud.find_child("HBoxContainer", true, false)
			
			if not hbox:
				for child in instance.inventory_hud.get_children():
					if child is HBoxContainer:
						hbox = child
						break
			
			if hbox:
				return add_item_to_simple_hud(item_name, texture, count, hbox)
			else:
				print("ОШИБКА: HBoxContainer не найден в инвентаре!")
				return false
	else:
		print("Неизвестный тип инвентаря:", instance.inventory_hud.get_class())
		return false

# Добавление предмета в простой HUD инвентарь
static func add_item_to_simple_hud(item_name: String, texture: Texture, count: int, hbox: HBoxContainer) -> bool:
	# Ищем пустой слот или слот с таким же предметом
	for i in range(hbox.get_child_count()):
		var slot = hbox.get_child(i)
		
		# Ищем иконку в слоте
		var icon = null
		for child in slot.get_children():
			if child.name == "Icon" or child is TextureRect:
				icon = child
				break
		
		if icon:
			# Если иконка скрыта (пустой слот)
			if not icon.visible:
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
		
	print("✗ Нет свободных слотов")
	return false

# Функция для закрытия диалога
static func hide_dialog():
	if instance and instance.dialog:
		instance.dialog.hide()
		print("Диалог закрыт")

# Получить текстуру предмета по имени
func get_item_texture(item_name: String) -> String:
	match item_name:
		"Золотая монета":
			return "res://assets/wood_tile.png"
		"Ключ":
			return "res://assets/player.png"
		"Зелье здоровья":
			return "res://assets/tileset.png"
		"Карта сокровищ":
			return "res://assets/wood_tile.png"
		"Волшебный кристалл":
			return "res://assets/player.png"  # Или создайте отдельную текстуру для кристалла
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
			(viewport_size.x - interaction_prompt.size.x) / 2,
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
			(viewport_size.x - message_label.size.x) / 2,
			(viewport_size.y - message_label.size.y) / 3  # Помещаем выше центра
		)
		message_label.show()
		message_timer.start(duration)

func _on_message_timeout():
	if message_label:
		message_label.hide()

func _input(event):
	# Добавляем горячие клавиши для управления окном
	if event is InputEventKey and event.pressed:
		# F11 - переключение полноэкранного режима
		if event.keycode == KEY_F11:
			toggle_fullscreen()
		# Alt+Enter - тоже переключение полноэкранного режима
		elif event.keycode == KEY_ENTER and event.alt_pressed:
			toggle_fullscreen()

# ============= НОВЫЕ ФУНКЦИИ ДЛЯ ПРОВЕРКИ ИНВЕНТАРЯ =============

# Проверить наличие предмета в инвентаре
static func has_item_in_inventory(item_name: String, min_count: int = 1) -> bool:
	if not instance or not instance.inventory_hud:
		print("ОШИБКА: HUD инвентарь не создан")
		return false
	
	# Если инвентарь имеет метод has_item (как в InventoryHUD.gd)
	if instance.inventory_hud.has_method("has_item"):
		return instance.inventory_hud.has_item(item_name, min_count)
	
	# Иначе используем альтернативный способ проверки (для простого инвентаря)
	print("Предупреждение: Инвентарь не имеет метода has_item, используется альтернативная проверка")
	return false

# Удалить предмет из инвентаря
static func remove_item_from_inventory(item_name: String, count: int = 1) -> bool:
	if not instance or not instance.inventory_hud:
		print("ОШИБКА: HUD инвентарь не создан")
		return false
	
	# Если инвентарь имеет метод remove_item (как в InventoryHUD.gd)
	if instance.inventory_hud.has_method("remove_item"):
		return instance.inventory_hud.remove_item(item_name, count)
	
	# Иначе используем альтернативный способ удаления (для простого инвентаря)
	print("Предупреждение: Инвентарь не имеет метода remove_item, используется альтернативное удаление")
	return false

# Получить количество предмета в инвентаре
static func get_item_count(item_name: String) -> int:
	if not instance or not instance.inventory_hud:
		print("ОШИБКА: HUD инвентарь не создан")
		return 0
	
	# Если инвентарь имеет метод get_items (как в InventoryHUD.gd)
	if instance.inventory_hud.has_method("get_items"):
		var items = instance.inventory_hud.get_items()
		for item in items:
			if item.get("name") == item_name:
				return item.get("count", 0)
	
	return 0

# Получить список всех предметов в инвентаре
static func get_inventory_items() -> Array:
	if not instance or not instance.inventory_hud:
		print("ОШИБКА: HUD инвентарь не создан")
		return []
	
	# Если инвентарь имеет метод get_items (как в InventoryHUD.gd)
	if instance.inventory_hud.has_method("get_items"):
		return instance.inventory_hud.get_items()
	
	return []
