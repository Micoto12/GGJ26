extends CanvasLayer

var is_open = false
@onready var items_label: Label

func _ready():
	print("Инвентарь загружен")
	hide()
	
	# Находим лейбл для предметов (если он есть)
	if has_node("Panel/ItemsLabel"):
		items_label = $Panel/ItemsLabel
	else:
		# Создаем лейбл если его нет
		create_items_label()

func create_items_label():
	# Создаем лейбл для предметов
	items_label = Label.new()
	items_label.name = "ItemsLabel"
	items_label.position = Vector2(50, 80)
	items_label.size = Vector2(400, 250)
	items_label.vertical_alignment = VERTICAL_ALIGNMENT_TOP
	items_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	items_label.add_theme_font_size_override("font_size", 20)
	items_label.add_theme_color_override("font_color", Color(1, 1, 1))
	
	$Panel.add_child(items_label)

func _input(event):
	# Открываем/закрываем по клавише I
	if event.is_action_pressed("inventory"):
		toggle()

func toggle():
	if is_open:
		close()
	else:
		open()

func open():
	is_open = true
	show()
	print("Инвентарь открыт")
	
	# Обновляем отображение предметов при открытии
	update_display()

func close():
	is_open = false
	hide()
	print("Инвентарь закрыт")

# Функция для обновления отображения
func update_display():
	if items_label:
		var items = Global.get_inventory_items()
		var text = "🎒 ИНВЕНТАРЬ:\n\n"
		
		if items.size() == 0:
			text += "   Пусто\n   (откройте сундук!)"
		else:
			for item in items:
				text += "   • " + item["name"] + " x" + str(item["count"]) + "\n"
		
		items_label.text = text
		print("Обновлено отображение инвентаря")
