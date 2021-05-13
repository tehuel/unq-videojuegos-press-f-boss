extends Area2D

onready var animation = $AnimationPlayer

func attack():
	animation.play("swing")
#	yield(animation,"animation_finished")
	animation.play_backwards("swing")
	return false
