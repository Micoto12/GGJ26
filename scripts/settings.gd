extends Control
func _ready():
	load_slider_position()

func load_slider_position():
	var config = ConfigFile.new()
	var error = config.load("user://settings.cfg")
	var volume_slider_node = find_child("VolumeSlider") # Находим ползунок

	if error == OK and volume_slider_node:
		# Читаем сохраненное значение
		var saved_volume = config.get_value("Audio", "MasterVolume", 1.0)
		
		# Устанавливаем позицию ползунка на загруженное значение
		volume_slider_node.value = saved_volume
		
		# Также сразу применяем громкость (на всякий случай)
		_on_volume_slider_value_changed(saved_volume)
func _on_volume_slider_value_changed(value: float) -> void:
	var bus_index = AudioServer.get_bus_index("Master")
	var db_value = linear_to_db(value)
	AudioServer.set_bus_volume_db(bus_index, db_value)

func _on_button_pressed() -> void: # Предполагается, что это кнопка "Назад"
	var config = ConfigFile.new()
	
	# Используем find_child() для поиска ползунка по имени
	var volume_slider_node = find_child("VolumeSlider") 

	if volume_slider_node:
		# Убедимся, что значение записывается
		print("Сохраняем громкость: ", volume_slider_node.value) 
		config.set_value("Audio", "MasterVolume", volume_slider_node.value)
		
		# Файл user://settings.cfg будет создан автоматически здесь
		var error = config.save("user://settings.cfg")
		if error != OK:
			print("ОШИБКА сохранения файла: ", error)

	get_tree().change_scene_to_file("res://scene/main_menu.tscn")
