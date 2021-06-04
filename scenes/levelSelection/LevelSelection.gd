extends Node2D

func _ready():
	
	# cambio un poco la animación, para que no se vean tan iguales
	$Island1.get_node("AnimationPlayer").advance(4)
	$Island1.get_node("AnimationPlayer").set_speed_scale(1.5)
	
	$Island2.get_node("AnimationPlayer").advance(9)
	$Island2.get_node("AnimationPlayer").set_speed_scale(2.8)
	
	$Island3.get_node("AnimationPlayer").advance(1)
	$Island3.get_node("AnimationPlayer").set_speed_scale(0.8)
	
	$Island4.get_node("AnimationPlayer").advance(5)

func _process(_delta):
	if (Input.is_action_just_pressed("select_level_a")):
		_start_level(1)

	if (Input.is_action_just_pressed("select_level_b")):
		_start_level(2)

	if (Input.is_action_just_pressed("select_level_c")):
		_start_level(3)

	if (Input.is_action_just_pressed("select_level_d")):
		_start_level(4)

	if (Input.is_action_just_pressed("ui_cancel")):
# warning-ignore:return_value_discarded
		get_tree().change_scene("res://scenes/mainMenu/MainMenu.tscn")

func _start_level(level): 
	Game.currentLevel = level
	print("starting level ", level)
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://scenes/game/Game.tscn")
	
