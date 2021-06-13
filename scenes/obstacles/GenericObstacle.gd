extends Node

onready var sprite = $sprite
onready var collision = $collision

func _ready():
	self.scale = self.scale * rand_range(0.2, 0.5)
	
	var rotation = rand_range(-30, 30)
	sprite.rotation_degrees = rotation
	collision.rotation_degrees = rotation
	
	sprite.modulate = Color.from_hsv(rand_range(0.0, 1), 0.12, 1, 1)
