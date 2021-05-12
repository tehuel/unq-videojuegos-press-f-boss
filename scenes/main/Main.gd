extends Node

func _ready():
	$Player.start($StartPosition.position)
	$MeleeEnemy.initialize($Navigation2D, self)
	$RangedEnemy.initialize($Navigation2D, self)
