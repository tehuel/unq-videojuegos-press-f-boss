extends Node

func _ready():
	$Player.start($StartPosition.position, self)
	$MeleeEnemy.initialize($Navigation2D, self)
	$RangedEnemy.initialize($Navigation2D, self)
