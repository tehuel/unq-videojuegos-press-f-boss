extends Node2D

func _process(_delta):
	var inputEnter = Input.is_action_just_pressed("ui_accept") || Input.is_action_just_pressed("left_click") || Input.is_action_just_pressed("ui_cancel")
	if (inputEnter && !$AnimationPlayer.is_playing()):
		Game.set_current_level(1)
		get_tree().change_scene("res://scenes/mainMenu/MainMenu.tscn")
