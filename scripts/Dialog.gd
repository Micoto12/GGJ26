extends CanvasLayer

class_name Dialog

signal item_taken(item_name: String)
signal dialog_closed

@onready var panel = $Panel
@onready var message_label = $Panel/Label
@onready var take_button = $Panel/TakeButton
@onready var cancel_button = $Panel/CancelButton

var current_item: String = ""

func _ready():
	hide()  # Скрываем диалог при загрузке
	# Устанавливаем красивые стили для кнопок
	setup_button_styles()

func setup_button_styles():
	# Стиль кнопки "Взять"
	var take_button_style = StyleBoxFlat.new()
	take_button_style.bg_color = Color(0.2, 0.6, 0.2)
	take_button_style.border_color = Color(0.4, 0.9, 0.4)
	take_button_style.border_width_left = 2
	take_button_style.border_width_right = 2
	take_button_style.border_width_top = 2
	take_button_style.border_width_bottom = 2
	take_button_style.corner_radius_top_left = 8
	take_button_style.corner_radius_top_right = 8
	take_button_style.corner_radius_bottom_left = 8
	take_button_style.corner_radius_bottom_right = 8
	
	take_button.add_theme_stylebox_override("normal", take_button_style)
	take_button.add_theme_font_size_override("font_size", 20)
	take_button.add_theme_color_override("font_color", Color(1, 1, 1))
	
	# Эффект при наведении
	var take_button_hover = take_button_style.duplicate()
	take_button_hover.bg_color = Color(0.3, 0.7, 0.3)
	take_button.add_theme_stylebox_override("hover", take_button_hover)
	
	# Стиль кнопки "Отмена"
	var cancel_button_style = StyleBoxFlat.new()
	cancel_button_style.bg_color = Color(0.6, 0.2, 0.2)
	cancel_button_style.border_color = Color(0.9, 0.4, 0.4)
	cancel_button_style.border_width_left = 2
	cancel_button_style.border_width_right = 2
	cancel_button_style.border_width_top = 2
	cancel_button_style.border_width_bottom = 2
	cancel_button_style.corner_radius_top_left = 8
	cancel_button_style.corner_radius_top_right = 8
	cancel_button_style.corner_radius_bottom_left = 8
	cancel_button_style.corner_radius_bottom_right = 8
	
	cancel_button.add_theme_stylebox_override("normal", cancel_button_style)
	cancel_button.add_theme_font_size_override("font_size", 20)
	cancel_button.add_theme_color_override("font_color", Color(1, 1, 1))
	
	# Эффект при наведении
	var cancel_button_hover = cancel_button_style.duplicate()
	cancel_button_hover.bg_color = Color(0.7, 0.3, 0.3)
	cancel_button.add_theme_stylebox_override("hover", cancel_button_hover)

func show():
	.show()
	# Центрируем при каждом показе
	var viewport_size = get_viewport().size
	panel.position = Vector2(
		(viewport_size.x - panel.size.x) / 2,
		viewport_size.y - panel.size.y - 40
	)
	print("Диалог показан внизу по центру")

func show_dialog(item_name: String, item_description: String = ""):
	current_item = item_name
	var text = "Вы нашли: " + item_name
	if item_description != "":
		text += "\n\n" + item_description
	text += "\n\nВзять предмет?"
	
	message_label.text = text
	show()

func hide_dialog():
	hide()
	dialog_closed.emit()
	print("Диалог скрыт")

func _on_take_button_pressed():
	print("Взят предмет:", current_item)
	item_taken.emit(current_item)
	hide_dialog()

func _on_cancel_button_pressed():
	print("Отмена взятия предмета")
	hide_dialog()
