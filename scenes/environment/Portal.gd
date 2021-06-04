extends Area2D

onready var first = $center
onready var second = $circle
onready var third = $braid
onready var fourth = $runes
onready var last = $Particles2D
onready var collision = $CollisionShape2D

func _ready():
	$AnimationPlayer.play("spin")
	first.hide()
	second.hide()
	third.hide()
	fourth.hide()
	last.hide()
	collision.disabled = true

func enable_first():
	first.show()

func enable_second():
	second.show()

func enable_third():
	third.show()

func enable_fourth():
	fourth.show()

func enable_last():
	last.show()
	collision.disabled = false

func _on_Portal_body_entered(body):
	if body.is_in_group("player"):
# warning-ignore:return_value_discarded
		Game.currentLevel +=1
		get_tree().change_scene("res://scenes/game/Game.tscn")
