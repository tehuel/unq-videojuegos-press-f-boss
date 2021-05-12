extends BaseWeapon

onready var animation = $AnimationPlayer

func attack():
	self.monitoring = true
	animation.play("swing")

func stop_attack():
	self.monitoring = false
	
func _on_Weapon_body_entered(body):
	hit(body)

func _on_BodyDetection_body_entered(_body):
	_target_in_range()

func _on_BodyDetection_body_exited(_body):
	_target_out_of_range()
