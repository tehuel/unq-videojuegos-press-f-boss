extends Node

var rng = RandomNumberGenerator.new()
var enemiesLeft = 0
var portal_phase_every = 0
var next_portal_phase_in = -1
var current_portal_phase = 0

onready var meleeEnemy = load("res://scenes/enemies/MeleeEnemy.tscn")
onready var rangedEnemy = load("res://scenes/enemies/RangedEnemy.tscn")
onready var enemiesContainer = get_parent()
onready var enemyAudioDie = $AudioDie
onready var portal = get_node("../Portal")

func generate_enemies(placed_list):
	
	var config = _get_enemies_config(Game.level)
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
			
			new_enemy.initialize(enemiesContainer, enemyAudioDie)
			var _try_pos
			var is_invalid_pos = true
			while(is_invalid_pos):
				is_invalid_pos = false
				_try_pos = _get_random_vector2(64*5, 64 * (Game.level_size-2))
				for placed in placed_list:
					if (_check_positions_in_tiles(_try_pos, placed.position)):
						is_invalid_pos = true
						break;
			new_enemy.position = _try_pos
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

# Ac?? podr??a tener varias configs para cada nivel, para agregar un poco mas de variedad
func _get_enemies_config(level):
	var enemiesConfig
	match level:
		1:
			enemiesConfig =  {
				"melee": {
					"quantity": 2,
					"min_health": 5,
					"max_health": 15,
					"min_armor": 0,
					"max_armor": 10,
					"min_strength": 1,
					"max_strength": 2,
					"min_speed": 200,
					"max_speed": 300
				},
				"ranged": {
					"quantity": 2,
					"min_health": 5,
					"max_health": 15,
					"min_armor": 0,
					"max_armor": 10,
					"min_strength": 1,
					"max_strength": 1,
					"min_speed": 200,
					"max_speed": 250
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

func _get_random_vector2(minimum, maximum):
	rng.randomize()
	var x = rng.randi_range(minimum, maximum)
	var y = rng.randi_range(minimum, maximum)
	return Vector2(x, y)

func _check_positions_in_tiles(pos1, pos2):
	var res = 64 * 3
	var simplifiedPos1 = Vector2(int(pos1.x / res), int(pos1.y / res))
	var simplifiedPos2 = Vector2(int(pos2.x / res), int(pos2.y / res))
	var checkPos = simplifiedPos1 == simplifiedPos2
	var checkLeft = Vector2(simplifiedPos1.x -64, simplifiedPos1.y) == simplifiedPos2
	var checkRight = Vector2(simplifiedPos1.x +64, simplifiedPos1.y) == simplifiedPos2
	var checkTop = Vector2(simplifiedPos1.x, simplifiedPos1.y -64) == simplifiedPos2
	var checkDown = Vector2(simplifiedPos1.x, simplifiedPos1.y +64) == simplifiedPos2
	return checkPos || checkLeft || checkRight || checkTop || checkDown
