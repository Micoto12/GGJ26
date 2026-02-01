extends Control

func _ready():
	$CenterContainer/Main/StartButton.grab_focus()
	Music.play("menu")
	
	# Скрываем игровые UI элементы в меню
	if Global:
		# Если инвентарь есть - скрываем
		if Global.inventory_hud and Global.inventory_hud.visible:
			Global.inventory_hud.hide()
		
		# Скрываем диалог если он виден
		if Global.dialog and Global.dialog.visible:
			Global.dialog.hide()

func _on_start_button_pressed() -> void:
	# Инициализируем игровой UI перед началом игры

	
	# Даем время на создание UI
	await get_tree().create_timer(0.1).timeout
	
	get_tree().change_scene_to_file("res://scene/INTRO.tscn")

func _on_exit_button_pressed() -> void:
	get_tree().quit()

func _on_settings_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scene/Settings.tscn")
