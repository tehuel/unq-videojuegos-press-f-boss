extends Area2D
class_name BaseProjectile

onready var timer = $DeleteTimer

export (float) var projectile_speed = 400

var _origin
var direction:Vector2

func initialize(origin, fire_direction:Vector2, initial_position:Vector2):
	_origin = origin
	global_position = initial_position
	direction = fire_direction
	timer.connect("timeout", self, "_on_DeleteTimer_timeout")
	timer.start()
	
	
func _physics_process(delta):
	position += direction * projectile_speed * delta

func _on_DeleteTimer_timeout():
	get_parent().remove_child(self)
	queue_free()

func _on_Projectile_body_entered(body):
	if _origin && body && body.has_method("on_hit"):
		_origin.hit(body)
	queue_free()
