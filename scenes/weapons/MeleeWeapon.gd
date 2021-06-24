extends BaseWeapon

onready var animation = $AnimationPlayer
onready var outPutStreamAxe = $AudioStreamAxe2D

var rng = RandomNumberGenerator.new()

func playSound():
	var numberSound = randomNumberBetween(0, 1)
	outPutStreamAxe.set_stream(outPutStreamAxe.axe_hit[numberSound])
	outPutStreamAxe.set_volume_db(-15.0)
	outPutStreamAxe.play()
	
func randomNumberBetween(numberOne, numberTwo):
	rng.randomize()
	return rng.randi_range(numberOne, numberTwo)

func attack():
	if _can_attack:
		self.monitoring = true
		animation.playback_speed = 1.0
		animation.play("swing")
		playSound()
		_can_attack = false

func stop_attack():
	self.monitoring = false
	if _holder.is_in_group("player"):
		animation.playback_speed = 5.0
#	animation.play_backwards("swing")
	yield(animation, "animation_finished")
	_can_attack = true

func _on_Weapon_body_entered(body):
	hit(body)

func _on_BodyDetection_body_entered(_body):
	_target_in_range()

func _on_BodyDetection_body_exited(_body):
	_target_out_of_range()


func _on_MeleeWeapon_area_entered(area):
	if is_instance_valid(area) && area.has_method("destroy"):
		outPutStreamAxe.set_stream(outPutStreamAxe.parry)
		outPutStreamAxe.set_volume_db(-20.0)
		outPutStreamAxe.play()
		area.destroy()
