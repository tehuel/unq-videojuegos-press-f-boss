extends Node

onready var axeSFX = $AxeSound
onready var winfSFX = $Wind
onready var camera = $CameraMainMenu
signal started_pressed

func _ready():
	$VBoxContainer/VBoxContainer/Start.grab_focus()
	$VBoxContainer/VBoxContainer/Start.disabled = false

func _on_Start_pressed():
	print("Start pressed")
	$VBoxContainer/VBoxContainer/Start.disabled = true
	axeSFX.play()
	winfSFX.play()
	yield(axeSFX, "finished")
	emit_signal("started_pressed")
	camera.move_local_y(-7000)

func _on_Exit_pressed():
	print("Exit pressed")
	get_tree().quit()
	
