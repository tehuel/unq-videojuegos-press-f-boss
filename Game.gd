extends Node

var level = 1
var level_size
var level_obstacles
var level_center

func _ready():
	set_current_level(1)

func set_current_level(level):
	self.level = level;
	self.level_size = 6 + (level * 8)
	self.level_obstacles = (level * 4)
	self.level_center = 32 + ((level_size * 64) / 2)
