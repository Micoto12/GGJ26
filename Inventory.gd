extends CanvasLayer

class_name Inventory

@onready var panel = $Panel
var is_open = false

func _ready():
	print("Инвентарь загружен")
	hide()  # Скрываем при старте

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

func close():
	is_open = false
	hide()
	print("Инвентарь закрыт")

# Простая функция для отладки
func show_message(text: String):
	print("[Инвентарь]: ", text)
