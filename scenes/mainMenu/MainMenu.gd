extends Node

onready var axeSFX = $AxeSound
onready var winfSFX = $Wind
onready var pageSFX = $PageSFX
onready var startSFX = $StartSong
onready var camera = $CameraMainMenu
onready var controls = $Controls/Control
onready var backGroundSFX = $BackGround
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
	backGroundSFX.stop()
	startSFX.play()

func _on_Exit_pressed():
	print("Exit pressed")
	get_tree().quit()
	

func _on_Controls_pressed():
	print("Controlls pressed")
	pageSFX.play()
	controls.visible = true
	
func _input(event):
	if event.is_action_pressed("ui_cancel"):
		controls.visible = false
