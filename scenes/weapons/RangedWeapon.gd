extends BaseWeapon

export (PackedScene) var projectile_scene

onready var fire_position = $FirePosition

func attack():
	if _can_attack:
		_can_attack = false
		var newProjectile = projectile_scene.instance()
		_holder.container.add_child(newProjectile)
		newProjectile.initialize(self, (fire_position.global_position - global_position).normalized(), fire_position.global_position)
		_timer.start()

func _on_timeout_complete():
	_can_attack = true

func _on_Weapon_body_entered(_body):
	_target_in_range()

func _on_Weapon_body_exited(_body):
	_target_out_of_range()
