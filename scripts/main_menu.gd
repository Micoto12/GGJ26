extends Control

func _ready():
	$CenterContainer/Main/StartButton.grab_focus()
	Music.play("menu")  # Запуск музыки меню

func _on_exit_button_pressed() -> void:
	get_tree().quit()

func _on_settings_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scene/Settings.tscn")

func _on_start_button_pressed() -> void:	
	get_tree().change_scene_to_file("res://scene/map.tscn")
