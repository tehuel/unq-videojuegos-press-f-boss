extends Area2D

export (float) var duration:float = 0.3

var _duration_timer
var _target

func _ready():
	$AnimationPlayer.play("AnimatedPowerUp")
	_duration_timer = Timer.new()
	_duration_timer.wait_time = duration
	_duration_timer.one_shot = true
	_duration_timer.connect("timeout", self, "on_duration_finish")
	add_child(_duration_timer)

func _on_PowerUp_body_entered(body):
	if body.is_in_group("player"):
		$CollisionShape2D.set_deferred("set_monitoring",false)
		_target = body
		_target._invincible = true
		self.hide()
		_duration_timer.start()
		
func on_duration_finish():
	_target._invincible = false
	call_deferred("queue_free")
