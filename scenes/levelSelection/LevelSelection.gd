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
