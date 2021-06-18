extends Node

onready var map = get_node("../TileMap")
onready var portal = get_node("../Portal")
onready var rock2 = load("res://scenes/obstacles/Rock2.tscn")
onready var rock3 = load("res://scenes/obstacles/Rock3.tscn")
onready var tree = load("res://scenes/obstacles/Tree.tscn")
onready var obstaclesList = [rock2, rock3, tree];
onready var player_camera = get_node("../Player/Camera2D")
onready var enemy_gen = get_node("../EnemyGenerator")

var rng = RandomNumberGenerator.new()
var placedInLevel = [];

const tiles = {
	"wall": 0,
	"grass": 1,
}

func generate_random_map():
	rng.randomize()
	
	_delete_obstacles()
	_draw_empty_map(Game.level_size)
	placedInLevel.append(get_node("../StartPosition"))
	portal.position = Vector2(Game.level_center, Game.level_center)
	placedInLevel.append(portal)
	_place_random_obstacles(Game.level_obstacles)
	enemy_gen.generate_enemies(placedInLevel)
	player_camera.limit_bottom = Game.level_center * 2
	player_camera.limit_right = Game.level_center * 2


func _draw_empty_map(size:int):
	map.clear()
	_fill_map_with_floor(size)
	_fill_map_walls(size)


func _fill_map_with_floor(size:int):
	map.clear()
	for x in range(size):
		for y in range(size):
			var tile = int(min(int(rand_range(1,15)), 5))
			map.set_cellv(Vector2(x,y), tile)


func _fill_map_walls(size:int):
	for i in range(size):
		map.set_cellv(Vector2(0,i), tiles.wall)
		map.set_cellv(Vector2(i,0), tiles.wall)
		map.set_cellv(Vector2(i,size), tiles.wall)
		map.set_cellv(Vector2(size,i), tiles.wall)
		map.set_cellv(Vector2(size,size), tiles.wall)


func _delete_obstacles():
	var currentObstacle = placedInLevel.pop_back()
	while(currentObstacle):
		currentObstacle.queue_free()
		currentObstacle = placedInLevel.pop_back()


func _place_random_obstacles(amount):
	for _i in range(amount):
		#print("ubicando nuevo objeto")
		var newObstacle = _get_random_obstacle_type().instance();
		
		# asigno posiciones random hasta encontrar una posicion no ocupada
		var newObstaclePossiblePosition
		var positionInvalid = true
		while(positionInvalid):
			positionInvalid = false
			# asigno una nueva posicion y pruebo con todos los obstáculos existentes en el nivel
			newObstaclePossiblePosition = _get_random_vector2(64*5, 64 * (Game.level_size-2))
			for curObstacle in placedInLevel:
				#print("chequeo contra objeto en ", newObstaclePossiblePosition, curObstacle.position)
				if (_check_positions_in_tiles(newObstaclePossiblePosition, curObstacle.position)):
					#print("posicion erronea, reacomodando!")
					positionInvalid = true
					break;
		
		#print("objeto ubicado en ", newObstaclePossiblePosition)
		newObstacle.position = newObstaclePossiblePosition
		get_parent().add_child(newObstacle)
		placedInLevel.append(newObstacle)

# divido posiciones en base 64, que es el tamaño de un tile
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

func _get_random_obstacle_type():
	var size = obstaclesList.size()
	return obstaclesList[randi() % size]


func _get_random_vector2(minimum, maximum):
	rng.randomize()
	var x = rng.randi_range(minimum, maximum)
	var y = rng.randi_range(minimum, maximum)
	return Vector2(x, y)


