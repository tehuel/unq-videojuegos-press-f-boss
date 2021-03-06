extends Area2D

export (float) var duration:float = 4.5

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
	if body.is_in_group("player") && body.has_method("on_power"):
		$CollisionShape2D.set_deferred("disabled", true)
		_target = body
		_target.strength *=  2
		_target.on_power(true)
		$StrengthAudio.play()
		self.hide()
		_duration_timer.start()
		
func on_duration_finish():
	_target.strength /= 2
	_target.on_power(false)
	call_deferred("queue_free")
