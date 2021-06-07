extends Node

var rng = RandomNumberGenerator.new()
var enemiesLeft = 0
var portal_phase_every = 0
var next_portal_phase_in = -1
var current_portal_phase = 0

onready var meleeEnemy = load("res://scenes/enemies/MeleeEnemy.tscn")
onready var rangedEnemy = load("res://scenes/enemies/RangedEnemy.tscn")
onready var navigation = get_node("../Navigation2D")
onready var enemiesContainer = get_parent()
onready var enemyAudioDie = $AudioDie
onready var portal = get_node("../Portal")

func generate_enemies():
	
	var config = _get_enemies_config(Game.currentLevel)
	enemiesLeft = config["melee"].quantity + config["ranged"].quantity
	portal_phase_every = ceil(enemiesLeft / 5.0)
	next_portal_phase_in = portal_phase_every
	
	# Para cada uno de los tipos de enemigos que hay
	for enemyType in ["melee", "ranged"]:
		var enemyTypeConfig = config[enemyType]
		var quantity = enemyTypeConfig.quantity
		
		# creo la cantidad definida en la config
		for _i in quantity:
			var new_enemy
			match enemyType:
				"melee":
					 new_enemy = meleeEnemy.instance()
				"ranged":
					 new_enemy = rangedEnemy.instance()
			
			new_enemy.initialize(navigation, enemiesContainer, enemyAudioDie)
			new_enemy.position = Vector2(64*rng.randi_range(8, 30), 64*rng.randi_range(8, 30))
			new_enemy.z_index = -1;
			new_enemy.z_as_relative = true;
			new_enemy.health = rng.randi_range(enemyTypeConfig.min_health, enemyTypeConfig.max_health)
			new_enemy.armor = rng.randi_range(enemyTypeConfig.min_armor, enemyTypeConfig.max_armor)
			new_enemy.strength = rng.randi_range(enemyTypeConfig.min_strength, enemyTypeConfig.max_strength)
			new_enemy.speed = rng.randi_range(enemyTypeConfig.min_speed, enemyTypeConfig.max_speed)
			new_enemy.connect("enemy_died", self, "_on_enemy_died")
			enemiesContainer.add_child(new_enemy)
			

func _on_enemy_died():
	print("enemy died, signal received")
	enemiesLeft -= 1
	next_portal_phase_in -= 1
	if next_portal_phase_in == 0:
		next_portal_phase_in = portal_phase_every
		match current_portal_phase:
			0:
				portal.enable_first()
			1:
				portal.enable_second()
			2:
				portal.enable_third()
			3:
				portal.enable_fourth()
		current_portal_phase = (current_portal_phase + 1) % 5
	if !enemiesLeft:
		portal.enable_last()

# Acá podría tener varias configs para cada nivel, para agregar un poco mas de variedad
func _get_enemies_config(level):
	var enemiesConfig
	match level:
		1:
			enemiesConfig =  {
				"melee": {
					"quantity": 5,
					"min_health": 10,
					"max_health": 25,
					"min_armor": 5,
					"max_armor": 25,
					"min_strength": 1,
					"max_strength": 2,
					"min_speed": 330,
					"max_speed": 350
				},
				"ranged": {
					"quantity": 3,
					"min_health": 5,
					"max_health": 15,
					"min_armor": 0,
					"max_armor": 15,
					"min_strength": 1,
					"max_strength": 1,
					"min_speed": 280,
					"max_speed": 300
				},
			}
		2:
			enemiesConfig =  {
				"melee": {
					"quantity": 7,
					"min_health": 15,
					"max_health": 30,
					"min_armor": 7,
					"max_armor": 30,
					"min_strength": 1,
					"max_strength": 3,
					"min_speed": 330,
					"max_speed": 365
				},
				"ranged": {
					"quantity": 5,
					"min_health": 9,
					"max_health": 25,
					"min_armor": 2,
					"max_armor": 25,
					"min_strength": 1,
					"max_strength": 2,
					"min_speed": 280,
					"max_speed": 310
				},
			}
		3:
			enemiesConfig =  {
				"melee": {
					"quantity": 12,
					"min_health": 20,
					"max_health": 50,
					"min_armor": 10,
					"max_armor": 40,
					"min_strength": 2,
					"max_strength": 4,
					"min_speed": 330,
					"max_speed": 365
				},
				"ranged": {
					"quantity": 8,
					"min_health": 5,
					"max_health": 15,
					"min_armor": 5,
					"max_armor": 30,
					"min_strength": 1,
					"max_strength": 3,
					"min_speed": 280,
					"max_speed": 310
				},
			}
		_:
			enemiesConfig =  {
				"melee": {
					"quantity": 25,
					"min_health": 50,
					"max_health": 100,
					"min_armor": 30,
					"max_armor": 75,
					"min_strength": 2,
					"max_strength": 5,
					"min_speed": 330,
					"max_speed": 370
				},
				"ranged": {
					"quantity": 25,
					"min_health": 35,
					"max_health": 65,
					"min_armor": 15,
					"max_armor": 50,
					"min_strength": 2,
					"max_strength": 4,
					"min_speed": 280,
					"max_speed": 320
				},
			}
	
	return enemiesConfig
