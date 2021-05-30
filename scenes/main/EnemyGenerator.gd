extends Node

var rng = RandomNumberGenerator.new()
var enemiesLeft = 5

onready var meleeEnemy = load("res://scenes/enemies/MeleeEnemy.tscn")
onready var rangedEnemy = load("res://scenes/enemies/RangedEnemy.tscn")
onready var navigation = get_node("../Navigation2D")
onready var enemiesContainer = get_parent()

func generate_enemies():
	# creates needed number of enemies
	for i in enemiesLeft:
		var new_enemy = meleeEnemy.instance()
		new_enemy.initialize(navigation, enemiesContainer)
		new_enemy.position = Vector2(64*rng.randi_range(1, 30), 64*rng.randi_range(1, 30))
		new_enemy.connect("enemy_died", self, "_on_enemy_died")
		enemiesContainer.add_child(new_enemy)

func _on_enemy_died():
	print("enemy died, signal received")
	enemiesLeft -= 1
	if (!enemiesLeft):
		print("mission acomplished")
