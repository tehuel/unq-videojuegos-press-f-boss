extends Control

onready var page_sfx = $PageSFX
var isInputValid

func _input(event):
	if event.is_action_pressed("pause") and isInputValid:
		var new_pause_state = not get_tree().paused
		get_tree().paused = new_pause_state
		visible = new_pause_state
		page_sfx.play()
