extends Control

func _ready():
	# Путь был исправлен ранее с учетом имени "Main buttons"
	$CenterContainer/Main/StartButton.grab_focus()
	load_settings()

# Функции кнопок:
func _on_exit_button_pressed() -> void:
	print("Нажал на выход!")
	get_tree().quit()
func _on_settings_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scene/Settings.tscn")
func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scene/Game.tscn")

func load_settings():
	var config = ConfigFile.new()
	var error = config.load("user://settings.cfg")
	
	if error == OK:
		var saved_volume = config.get_value("Audio", "MasterVolume", 1.0)
		# Убедимся, что значение прочитано
		print("Загруженная громкость: ", saved_volume)
		
		var bus_index = AudioServer.get_bus_index("Master")
		var db_value = linear_to_db(saved_volume)
		AudioServer.set_bus_volume_db(bus_index, db_value)
	else:
		# Это сообщение появится при первом запуске, пока файла нет
		print("Файл настроек не найден или ошибка загрузки: ", error)
