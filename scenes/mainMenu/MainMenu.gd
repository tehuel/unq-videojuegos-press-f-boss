extends Node

onready var axeSFX = $AxeSound

func _ready():
	$VBoxContainer/VBoxContainer/Start.grab_focus()

func _on_Start_pressed():
	print("Start pressed")
	axeSFX.play()
	yield(axeSFX, "finished")
	get_tree().change_scene("res://scenes/main/Game.tscn")

func _on_Exit_pressed():
	print("Exit pressed")
	get_tree().quit()
