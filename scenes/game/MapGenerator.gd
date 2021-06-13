extends Node

onready var map = get_node("../Navigation2D/TileMap")
onready var rock2 = load("res://scenes/obstacles/Rock2.tscn")
onready var rock3 = load("res://scenes/obstacles/Rock3.tscn")
onready var tree = load("res://scenes/obstacles/Tree.tscn")
onready var obstaclesList = [rock2, rock3, tree];

var rng = RandomNumberGenerator.new()
var obstaclesPlacedInLevel = [];

const tiles = {
	"wall": 0,
	"grass": 1,
	"obstacle": 2,
}

func generate_random_map():
	rng.randomize()

	_fill_map_with_floor()
	_fill_map_walls()
	_delete_obstacles()
	_place_random_obstacles(15)


func _get_random_vector2(minimum, maximum):
	rng.randomize()
	var x = rng.randi_range(minimum, maximum)
	var y = rng.randi_range(minimum, maximum)
	return Vector2(x, y)


func _get_random_obstacle_type():
	var size = obstaclesList.size()
	return obstaclesList[randi() % size]


func _fill_map_with_floor():
	map.clear()
	for x in range(32):
		for y in range(32):
			map.set_cellv(Vector2(x,y), tiles.grass)


func _fill_map_walls():
	for i in range(32):
		map.set_cellv(Vector2(0,i), tiles.wall)
		map.set_cellv(Vector2(i,0), tiles.wall)
		map.set_cellv(Vector2(i,32), tiles.wall)
		map.set_cellv(Vector2(32,i), tiles.wall)
		map.set_cellv(Vector2(32,32), tiles.wall)


func _delete_obstacles():
	var currentObstacle = obstaclesPlacedInLevel.pop_back()
	while(currentObstacle):
		currentObstacle.queue_free()
		currentObstacle = obstaclesPlacedInLevel.pop_back()


func _place_random_obstacles(amount):
	for _i in range(amount):
		var obstacle = _get_random_obstacle_type().instance();
		obstacle.position = _get_random_vector2(2, 28) * 64
		get_parent().add_child(obstacle)
		obstaclesPlacedInLevel.append(obstacle)
