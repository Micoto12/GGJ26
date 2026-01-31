extends Control

@onready var master_slider: Slider = $VBoxContainer/VBoxContainer/HBoxContainer/MasterSlider
@onready var music_slider: Slider = $VBoxContainer/VBoxContainer/HBoxContainer2/MusicSlider
@onready var sfx_slider: Slider = $VBoxContainer/VBoxContainer/HBoxContainer3/SFXSlider
@onready var back_button: Button = $VBoxContainer/BackButton

func _ready():
	# Кнопка "Назад"
	back_button.connect("pressed", Callable(self, "_on_back_button_pressed"))

	# Сигналы ползунков
	master_slider.connect("value_changed", Callable(self, "_on_master_slider_value_changed"))
	music_slider.connect("value_changed", Callable(self, "_on_music_slider_value_changed"))
	sfx_slider.connect("value_changed", Callable(self, "_on_sfx_slider_value_changed"))

	# Инициализация ползунков по текущей громкости Music Autoload
	master_slider.value = Music.master_volume
	music_slider.value = Music.music_volume
	sfx_slider.value = Music.sfx_volume


# ----------------------------
# Общая функция для установки громкости с отключением при нуле
func set_bus_volume(bus_name: String, value: float) -> void:
	var bus_index = AudioServer.get_bus_index(bus_name)
	if value <= 0.01:  # минимальное значение — выключаем звук
		AudioServer.set_bus_volume_db(bus_index, -80)
	else:
		AudioServer.set_bus_volume_db(bus_index, linear_to_db(value))


# ----------------------------
# События изменения ползунков
func _on_master_slider_value_changed(value: float) -> void:
	Music.master_volume = value
	set_bus_volume("Master", value)

func _on_music_slider_value_changed(value: float) -> void:
	Music.music_volume = value
	set_bus_volume("Music", value)

func _on_sfx_slider_value_changed(value: float) -> void:
	Music.sfx_volume = value
	set_bus_volume("SFX", value)


# ----------------------------
# Кнопка "Назад"
func _on_back_button_pressed():
	get_tree().change_scene_to_file("res://scene/main_menu.tscn")
