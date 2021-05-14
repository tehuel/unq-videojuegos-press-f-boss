extends BaseWeapon

onready var animation = $AnimationPlayer

func attack():
	if _can_attack:
		self.monitoring = true
		animation.play("swing")
		_can_attack = false

func stop_attack():
	self.monitoring = false
	animation.play_backwards("swing")
	yield(animation, "animation_finished")
	_can_attack = true

func _on_Weapon_body_entered(body):
	hit(body)

func _on_BodyDetection_body_entered(_body):
	_target_in_range()

func _on_BodyDetection_body_exited(_body):
	_target_out_of_range()
