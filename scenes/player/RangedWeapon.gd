extends AnimatedSprite

onready var lifetime_timer = $LifeTimeTimer
onready var hitbox = $HitBox

export (float) var VELOCITY:float = 800.0

var direction:Vector2

func initialize(container, spawn_position:Vector2, direction:Vector2):
	container.add_child(self)
	self.direction = direction
	global_position = spawn_position
	lifetime_timer.connect("timeout", self, "_on_lifetime_timer_timeout")
	lifetime_timer.start()

func _physics_process(delta):
	position += direction * VELOCITY * delta

func _on_lifetime_timer_timeout():
	call_deferred("_remove")

func _remove():
	get_parent().remove_child(self)
	queue_free()

func _on_Hitbox_body_entered(body):
	if body.has_method("notify_hit"):
		body.notify_hit()
	hitbox.collision_mask = 0
	call_deferred("_remove")
