extends Node

var rng = RandomNumberGenerator.new()
var enemiesLeft = 0

onready var meleeEnemy = load("res://scenes/enemies/MeleeEnemy.tscn")
onready var rangedEnemy = load("res://scenes/enemies/RangedEnemy.tscn")
onready var navigation = get_node("../Navigation2D")
onready var enemiesContainer = get_parent()


func generate_enemies():
	var config = _get_enemies_config(1)
	
	# Para cada uno de los tipos de enemigos que hay
	for enemyType in ["melee", "ranged"]:
		var quantity = config[enemyType].quantity
		enemiesLeft += quantity
		
		# creo la cantidad definida en la config
		for _i in quantity:
			var new_enemy
			match enemyType:
				"melee":
					 new_enemy = meleeEnemy.instance()
				"ranged":
					 new_enemy = rangedEnemy.instance()
			
			new_enemy.initialize(navigation, enemiesContainer)
			new_enemy.position = Vector2(64*rng.randi_range(1, 30), 64*rng.randi_range(1, 30))
			new_enemy.connect("enemy_died", self, "_on_enemy_died")
			enemiesContainer.add_child(new_enemy)

func _on_enemy_died():
	print("enemy died, signal received")
	enemiesLeft -= 1
	if (!enemiesLeft):
		print("mission acomplished")

# Acá podría tener varias configs para cada nivel, para agregar un poco mas de variedad
func _get_enemies_config(level):
	match level:
		1:
			return {
				"melee": {
					"quantity": 5,
					"atk": 1,
					"def": 1,
					"hp": 10,
				},
				"ranged": {
					"quantity": 1,
					"atk": 1,
					"def": 1,
					"hp": 10,
				},
			}
		_:
			print("no config defined for level")
