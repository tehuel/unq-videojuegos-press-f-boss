extends Node

onready var map = get_node("../Navigation2D/TileMap")
onready var portal = get_node("../Portal")
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
	
	_delete_obstacles()
	_draw_empty_map(Game.level_size)
	_place_random_obstacles(Game.level_obstacles)
	
	portal.position = Vector2(Game.level_center, Game.level_center)


func _draw_empty_map(size:int):
	map.clear()
	_fill_map_with_floor(size)
	_fill_map_walls(size)


func _fill_map_with_floor(size:int):
	map.clear()
	for x in range(size):
		for y in range(size):
			map.set_cellv(Vector2(x,y), tiles.grass)


func _fill_map_walls(size:int):
	for i in range(size):
		map.set_cellv(Vector2(0,i), tiles.wall)
		map.set_cellv(Vector2(i,0), tiles.wall)
		map.set_cellv(Vector2(i,size), tiles.wall)
		map.set_cellv(Vector2(size,i), tiles.wall)
		map.set_cellv(Vector2(size,size), tiles.wall)


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


func _get_random_obstacle_type():
	var size = obstaclesList.size()
	return obstaclesList[randi() % size]


func _get_random_vector2(minimum, maximum):
	rng.randomize()
	var x = rng.randi_range(minimum, maximum)
	var y = rng.randi_range(minimum, maximum)
	return Vector2(x, y)


