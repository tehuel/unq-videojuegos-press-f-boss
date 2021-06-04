extends Node

func _ready():
	$MapGenerator.generate_random_map()
	$EnemyGenerator.generate_enemies()
	$Player.start($StartPosition.position, self)
	$Soundtrack.play()

func _process(_delta):
	if Input.is_action_just_pressed("generate_new_map"):
		$MapGenerator.generate_random_map()
