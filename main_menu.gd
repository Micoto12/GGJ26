extends Control

func _ready():
	$CenterContainer/VBoxContainer/StartButton.grab_focus()

func _on_start_pressed():
	get_tree().change_scene_to_file("res://scenes/Game.tscn")

func _on_settings_pressed():
	get_tree().change_scene_to_file("res://scenes/Settings.tscn")

func _on_exit_pressed():
	get_tree().quit()
