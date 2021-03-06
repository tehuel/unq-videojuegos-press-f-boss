extends Node

onready var axeSFX = $AxeSound
onready var winfSFX = $Wind
onready var pageSFX = $PageSFX
onready var startSFX = $StartSong
onready var camera = $CameraMainMenu
onready var controls = $CanvasLayer/Controls/Control
onready var credits = $CanvasLayer/Credits/Control
onready var backGroundSFX = $BackGround

var cameraSmoothness = 0.1;

signal started_pressed

func _ready():
	cameraSmoothness = 0.1;
	$CanvasLayer/VBoxContainer.visible = true
	$CanvasLayer/VBoxContainer/VBoxContainer/Start.grab_focus()
	$CanvasLayer/VBoxContainer/VBoxContainer/Start.disabled = false


func _process(_delta):
	# agrego offset a la camara
	$CameraMainMenu.offset = get_viewport().get_mouse_position() * cameraSmoothness;


func _on_Start_pressed():
	print("Start pressed")
	cameraSmoothness = 0;
	$CanvasLayer/VBoxContainer/VBoxContainer/Start.disabled = true
	$CanvasLayer/VBoxContainer.visible = false
	axeSFX.play()
	winfSFX.play()
	yield(axeSFX, "finished")
	emit_signal("started_pressed")
	camera.move_local_y(-7000)
	backGroundSFX.stop()
	startSFX.play()

func _on_Exit_pressed():
	print("Exit pressed")
	if OS.has_feature('JavaScript'):
		JavaScript.eval("window.close()")
	else:
		get_tree().quit()


func _on_Controls_pressed():
	print("Controlls pressed")
	pageSFX.play()
	controls.visible = true

func _on_Credits_pressed():
	print("Credits pressed")
	pageSFX.play()
	credits.visible = true

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		controls.visible = false
		credits.visible = false
