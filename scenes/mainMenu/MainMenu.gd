extends Node

onready var axeSFX = $AxeSound

func _ready():
	$VBoxContainer/VBoxContainer/Start.grab_focus()
	$VBoxContainer/VBoxContainer/Start.disabled = false

func _on_Start_pressed():
	print("Start pressed")
	$VBoxContainer/VBoxContainer/Start.disabled = true
	axeSFX.play()
	yield(axeSFX, "finished")
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://scenes/levelSelection/LevelSelection.tscn")

func _on_Exit_pressed():
	print("Exit pressed")
	get_tree().quit()
