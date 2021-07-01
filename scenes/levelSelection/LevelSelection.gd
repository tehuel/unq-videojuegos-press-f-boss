extends Node2D

onready var i1 = $ParallaxBackground/ParallaxLayer2/Island1
onready var i2 = $ParallaxBackground/ParallaxLayer2/Island1
onready var i3 = $ParallaxBackground/ParallaxLayer2/Island1
onready var animation = $AnimationPlayer

var end_game:int = 4

const animations = {
	1: "to_level_1",
	2: "to_level_2",
	3: "to_level_3",
	4: "to_valhalla",
}

func _ready():
	
	# cambio un poco la animación, para que no se vean tan iguales
	i1.get_node("AnimationPlayer").advance(4)
	i1.get_node("AnimationPlayer").set_speed_scale(1.5)
	
	i2.get_node("AnimationPlayer").advance(9)
	i2.get_node("AnimationPlayer").set_speed_scale(2.8)
	
	i3.get_node("AnimationPlayer").advance(1)
	i3.get_node("AnimationPlayer").set_speed_scale(0.8)
	
	animation.play(animations[Game.level])
	
func _process(_delta):
	
	var inputEnter = Input.is_action_just_pressed("ui_accept") || Input.is_action_just_pressed("left_click")
	
	if (inputEnter):	
		# entro al level cuando termina la animacion
		if (!animation.is_playing()):
			_start_level(Game.level)
		# acelero la animacion 
		else:
			animation.playback_speed = animation.playback_speed * 1.25

func _start_level(level): 
	Game.set_current_level(level)

	if(level == end_game):
#		print("end game")
# warning-ignore:return_value_discarded
		Game.set_current_level(1)
		get_tree().change_scene("res://scenes/theEnd/theEnd.tscn")
	else:
#		print("starting level ", level)
# warning-ignore:return_value_discarded
		get_tree().change_scene("res://scenes/game/Game.tscn")
		
