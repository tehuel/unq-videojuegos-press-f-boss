extends Node

onready var sprite = $sprite
onready var collision = $collision
onready var under = 0

func _ready():
	self.scale = self.scale * rand_range(0.2, 0.5)

	var rotation = rand_range(-30, 30)
	sprite.rotation_degrees = rotation
	collision.rotation_degrees = rotation

	sprite.modulate = Color.from_hsv(rand_range(0.0, 1), 0.12, 1, 1)


func _on_Under_body_entered(body):
	if body.is_in_group("player") || body.is_in_group("enemies"):
		self.modulate = "d7ffffff"
		under += 1


func _on_Under_body_exited(_body):
	under = max(under - 1, 0)
	if under == 0:
		self.modulate = "ffffffff"

