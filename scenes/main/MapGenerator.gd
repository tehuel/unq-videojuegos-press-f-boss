extends Node

onready var map = get_node("../Navigation2D/TileMap")

var rng = RandomNumberGenerator.new()

const tiles = {
	"wall": 0,
	"grass": 1,
	"obstacle": 2,
}

func _fill_map_with_floor():
	map.clear()
	for x in range(32):
		for y in range(32):
			map.set_cellv(Vector2(x,y), tiles.grass)

func generate_random_map():
	_fill_map_with_floor()
	rng.randomize()
	# agrego paredes
	for i in range(32):
		map.set_cellv(Vector2(0,i), tiles.wall)
		map.set_cellv(Vector2(i,0), tiles.wall)
		map.set_cellv(Vector2(i,32), tiles.wall)
		map.set_cellv(Vector2(32,i), tiles.wall)
		map.set_cellv(Vector2(32,32), tiles.wall)

	# agrego 15 obstáculos random
	for _i in range(15):
		var obstacleSize = _get_random_vector2(1, 3)
		var obstaclePosition = _get_random_vector2(1, 29)
		_add_obstacle(obstacleSize, obstaclePosition)
	
func _add_obstacle(size:Vector2, position:Vector2):
#	print("add obstacle: ", size, position)
	for x in size.x:
		for y in size.y:
			var draw_x = position.x + x
			var draw_y = position.y + y
			map.set_cellv(Vector2(draw_x,draw_y), tiles.obstacle)

func _get_random_vector2(minimum, maximum):
	rng.randomize()
	var x = rng.randi_range(minimum, maximum)
	var y = rng.randi_range(minimum, maximum)
	return Vector2(x, y)
