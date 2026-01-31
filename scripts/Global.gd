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

# Переменные для отслеживания размеров окна
var last_window_size: Vector2
var fullscreen_enabled: bool = true

func _ready():
	instance = self
	randomize()
	
	setup_window()
	create_interaction_prompt()
	create_message_label()
	create_hud_inventory()
	create_dialog()
	
	get_tree().root.size_changed.connect(_on_window_resized)
	print("Global.gd инициализирован")

func setup_window():
	var window = get_window()
	window.mode = Window.MODE_FULLSCREEN
	fullscreen_enabled = true
	window.min_size = Vector2(1024, 600)
	window.title = "Моя RPG Игра"
	DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
	last_window_size = window.size
	print("Размер окна установлен: ", last_window_size)

func create_hud_inventory():
	print("Создаю HUD инвентарь...")
	
	# Загружаем сцену инвентаря
	var hud_scene = load("res://scene/InventoryHUD.tscn")
	if hud_scene:
		inventory_hud = hud_scene.instantiate() as CanvasLayer
		if inventory_hud:
			inventory_hud.name = "InventoryHUD"
			inventory_hud.layer = 5
			get_tree().root.add_child(inventory_hud)
			print("✓ HUD инвентарь создан")
			update_inventory_position()
		else:
			print("✗ Не удалось создать инвентарь из сцены")
	else:
		print("✗ Не удалось загрузить сцену InventoryHUD.tscn")

func update_inventory_position():
	if inventory_hud:
		var hbox = inventory_hud.get_node_or_null("HBoxContainer")
		if hbox:
			var viewport_size = get_viewport().size
			hbox.position = Vector2(20, viewport_size.y - 100)

# ===== ФУНКЦИИ ДЛЯ РАБОТЫ С ИНВЕНТАРЕМ =====
static func add_to_hud(item_name: String, texture_path: String = "", count: int = 1) -> bool:
	if not instance or not instance.inventory_hud:
		print("ОШИБКА: Инвентарь не создан")
		return false
	
	# Загружаем текстуру
	var texture = null
	if texture_path != "":
		texture = load(texture_path)
		if not texture:
			print("Не удалось загрузить текстуру: ", texture_path)
			texture = load("res://assets/player.png")
	
	# Вызываем метод add_item инвентаря
	if instance.inventory_hud.has_method("add_item"):
		return instance.inventory_hud.add_item(item_name, texture, count)
	
	print("ОШИБКА: Инвентарь не имеет метода add_item")
	return false

static func get_item_count(item_name: String) -> int:
	if not instance or not instance.inventory_hud:
		print("ОШИБКА: Инвентарь не создан")
		return 0
	
	if instance.inventory_hud.has_method("get_item_count"):
		return instance.inventory_hud.get_item_count(item_name)
	
	print("ОШИБКА: Инвентарь не имеет метода get_item_count")
	return 0

static func remove_item_from_inventory(item_name: String, count: int = 1) -> bool:
	if not instance or not instance.inventory_hud:
		print("ОШИБКА: Инвентарь не создан")
		return false
	
	if instance.inventory_hud.has_method("remove_item"):
		return instance.inventory_hud.remove_item(item_name, count)
	
	print("ОШИБКА: Инвентарь не имеет метода remove_item")
	return false

# ===== ОСТАЛЬНОЙ КОД (без изменений) =====
func _on_window_resized():
	var current_size = get_window().size
	if current_size != last_window_size:
		last_window_size = current_size
		update_ui_positions()

func update_ui_positions():
	if interaction_prompt:
		var prompt_label = interaction_prompt.get_child(0) if interaction_prompt.get_child_count() > 0 else null
		if prompt_label and prompt_label.text != "":
			show_interaction_prompt(prompt_label.text)
	
	if message_label and message_label.visible:
		show_message(message_label.text, message_timer.time_left)
	
	if dialog and dialog.visible:
		update_dialog_position()
	
	if inventory_hud:
		update_inventory_position()

func update_dialog_position():
	if dialog_panel:
		var viewport_size = get_viewport().size
		var margin_bottom = 40
		var dialog_height = dialog_panel.size.y
		dialog_panel.position = Vector2(
			(viewport_size.x - dialog_panel.size.x) / 2,
			viewport_size.y - dialog_height - margin_bottom
		)

func create_dialog():
	print("Создаю диалоговое окно...")
	
	dialog = CanvasLayer.new()
	dialog.name = "Dialog"
	dialog.layer = 200
	
	dialog_panel = Panel.new()
	dialog_panel.name = "Panel"
	dialog_panel.size = Vector2(700, 300)
	
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
	
	dialog_buttons_container = VBoxContainer.new()
	dialog_buttons_container.name = "ButtonsContainer"
	dialog_buttons_container.position = Vector2(40, 180)
	dialog_buttons_container.size = Vector2(620, 100)
	dialog_buttons_container.set("theme_override_constants/separation", 10)
	dialog_panel.add_child(dialog_buttons_container)
	
	dialog.add_child(dialog_panel)
	get_tree().root.add_child(dialog)
	dialog.hide()
	
	print("✓ Диалоговое окно создано")

func clear_dialog_buttons():
	if dialog_buttons_container:
		for child in dialog_buttons_container.get_children():
			child.queue_free()

func create_dialog_button(button_text: String, callback: Callable = Callable()) -> Button:
	var button = Button.new()
	button.text = button_text
	button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	button.custom_minimum_size = Vector2(0, 50)
	button.focus_mode = Control.FOCUS_ALL
	
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
	
	var button_hover = button_style.duplicate()
	button_hover.bg_color = Color(0.3, 0.5, 0.7)
	button.add_theme_stylebox_override("hover", button_hover)
	
	var button_pressed = button_style.duplicate()
	button_pressed.bg_color = Color(0.1, 0.3, 0.5)
	button.add_theme_stylebox_override("pressed", button_pressed)
	
	if callback.is_valid():
		button.pressed.connect(func():
			callback.call()
			dialog.hide()
		)
	else:
		button.pressed.connect(func(): dialog.hide())
	
	return button

static func show_dialog(dialog_text: String, options: Array = []):
	if not instance or not instance.dialog:
		print("ОШИБКА: Диалог не создан")
		return
	
	if instance.dialog_label:
		instance.dialog_label.text = dialog_text
	
	instance.clear_dialog_buttons()
	
	if options.size() == 0:
		options.append({
			"text": "Закрыть",
			"callback": Callable()
		})
	
	for option in options:
		var button_text = option.get("text", "???")
		var callback = option.get("callback", Callable())
		var item_data = option.get("item_data", null)
		
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
		
		var button = instance.create_dialog_button(button_text, callback)
		instance.dialog_buttons_container.add_child(button)
	
	instance.dialog.show()
	print("Диалог показан")

func create_interaction_prompt():
	var canvas = CanvasLayer.new()
	canvas.layer = 10
	add_child(canvas)
	
	interaction_prompt = Panel.new()
	interaction_prompt.size = Vector2(200, 60)
	canvas.add_child(interaction_prompt)
	
	var label = Label.new()
	label.text = ""
	label.size = Vector2(200, 60)
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	interaction_prompt.add_child(label)
	
	interaction_prompt.hide()

func create_message_label():
	var canvas = CanvasLayer.new()
	canvas.layer = 20
	add_child(canvas)
	
	message_label = Label.new()
	message_label.text = ""
	message_label.size = Vector2(400, 100)
	message_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	message_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	
	message_label.add_theme_font_size_override("font_size", 36)
	message_label.add_theme_color_override("font_color", Color(1, 1, 0))
	message_label.add_theme_constant_override("outline_size", 4)
	message_label.add_theme_color_override("font_outline_color", Color(0, 0, 0))
	
	canvas.add_child(message_label)
	message_label.hide()
	
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

func _input(event):
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_F11:
			toggle_fullscreen()
		elif event.keycode == KEY_ENTER and event.alt_pressed:
			toggle_fullscreen()

func toggle_fullscreen():
	var window = get_window()
	
	if fullscreen_enabled:
		window.mode = Window.MODE_WINDOWED
		window.size = Vector2(1280, 720)
		window.position = (DisplayServer.screen_get_size() - window.size) / 2
		fullscreen_enabled = false
		print("Переключено в оконный режим")
	else:
		window.mode = Window.MODE_FULLSCREEN
		fullscreen_enabled = true
		print("Переключено в полноэкранный режим")
	
	update_ui_positions()
