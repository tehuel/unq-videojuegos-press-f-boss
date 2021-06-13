extends Node

var level = 1
var level_size = 6 + (level * 12)
var level_obstacles = (level * 6)
var level_center = 32 + ((level_size * 64) / 2)

func set_current_level(level):
	self.level = level;
	self.level_size = 6 + (level * 6)
	self.level_obstacles = (level * 6)
	self.level_center = 32 + ((level_size * 64) / 2)
