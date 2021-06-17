extends Node

var level = 1
var level_size
var level_obstacles
var level_center

func _ready():
	set_current_level(1)

func set_current_level(lvl):
	self.level = lvl;
	self.level_size = 6 + (lvl * 12)
	self.level_obstacles = (lvl * 4)
	self.level_center = 32 + ((lvl * 64) / 2)
