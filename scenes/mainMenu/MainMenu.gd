extends Node

onready var axeSFX = $AxeSound
onready var camera = $CameraMainMenu

func _ready():
	$VBoxContainer/VBoxContainer/Start.grab_focus()
	$VBoxContainer/VBoxContainer/Start.disabled = false

func _on_Start_pressed():
	print("Start pressed")
	$VBoxContainer/VBoxContainer/Start.disabled = true
	axeSFX.play()
	yield(axeSFX, "finished")
	camera.move_local_y(-7000)

func _on_Exit_pressed():
	print("Exit pressed")
	get_tree().quit()
	
