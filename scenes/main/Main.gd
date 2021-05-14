extends Node

func _ready():
	$MapGenerator.generate_random_map()
	$Player.start($StartPosition.position, self)
	$MeleeEnemy.initialize($Navigation2D, self)
	$MeleeEnemy2.initialize($Navigation2D, self)
	$RangedEnemy.initialize($Navigation2D, self)
	$RangedEnemy2.initialize($Navigation2D, self)

func _process(_delta):
	if Input.is_action_just_pressed("generate_new_map"):
		$MapGenerator.generate_random_map()
