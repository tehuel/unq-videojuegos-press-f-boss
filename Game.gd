extends Node

var level = 1
var level_size
var level_obstacles
var level_center
var player_position : KinematicBody2D = null

func _ready():
	set_current_level(1)

func set_current_level(lvl):
	self.level = lvl;
	self.level_size = 6 + (lvl * 12)
	self.level_obstacles = (lvl * 4)
	self.level_center = 32 + ((level_size * 64) / 2)
