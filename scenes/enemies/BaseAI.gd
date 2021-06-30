extends KinematicBody2D

class_name BaseAI


export (int) var speed:int = 300
export (int) var health:int = 3
export (int) var strength:int = 2
export (int) var armor:int = 0
export var enemy_color = Color("bc29f1")

onready var weapon = $Weapon
onready var healing_power_up = preload("res://scenes/environment/HealingPowerUp.tscn")
onready var invincible_power_up = preload("res://scenes/environment/InvincibilityPowerUp.tscn")
onready var damage_power_up = preload("res://scenes/environment/StrengthPowerUp.tscn")
onready var sprite = $Sprite
onready var armor_sprite = $Sprite/Sprite2
onready var shield_effect = $Sprite/ShieldEffect

var _cur_health
var _cur_armor
var _state = states.WANDER
var _target_in_attack_range = false
var _target_on_seek_area
var _target
var container
var _dieSound
var velocity = Vector2.ZERO
var _wander_wait_timer
var _wander_target
var rng = RandomNumberGenerator.new()
var blood = load("res://scenes/utils/blood.tscn")

enum states {WANDER, ATTACK, CHASE}

const DROP_RATE = 35 # % / 100

signal enemy_died

func initialize(cont, dieSound):
	container = cont
	_dieSound = dieSound
	randomize()

func _ready():
	_wander_wait_timer = Timer.new()
	_wander_wait_timer.set_one_shot(true)
	_wander_wait_timer.set_wait_time(3.0)
	_wander_wait_timer.connect("timeout", self, "_set_wander_target")
	add_child(_wander_wait_timer)
	_wander_wait_timer.start()
	_cur_health = health
	_cur_armor = armor
	sprite.material.set_shader_param("hp_color", enemy_color)
	sprite.material.set_shader_param("damage_color", Color("8b0000"))
	sprite.material.set_shader_param("sides", (randi() % 7) + 4)
	weapon.take_weapon(self)
	_update_hp_shader()
	if _cur_armor > 0:
		_update_armor_sprite()

func _process(_delta):
	match _state:
		states.WANDER:
			_wander()
		states.ATTACK:
			_attack()
		states.CHASE:
			_chase()

func _physics_process(_delta):
	sight_check()

	if _cur_health <=0:
		emit_signal("enemy_died")
		drop_power_up()
		if(_dieSound != null):
			_dieSound.play()
		blood_floor()
		queue_free()

func blood_floor(scale = 1):
	var blood_instance : CPUParticles2D = blood.instance()
	blood_instance.scale = Vector2(scale, scale)
	get_tree().current_scene.add_child(blood_instance)
	blood_instance.global_position = global_position
	blood_instance.rotation = global_position.angle_to_point(Game.player_position.global_position)

func _attack():
	weapon.attack()

func _wander():
	if _wander_target:
		if position.distance_to(_wander_target) <= 16:
			_wander_target = null
			_wander_wait_timer.start()
		else:
			var steering = _wander_steering()
			velocity = _truncate(velocity + steering, speed)
			velocity = move_and_slide(velocity)
			rotation = velocity.angle()

func _wander_steering():
	return (((_wander_target - position).normalized() * (speed)) - velocity) + _avoid(_wander_target)

func _set_wander_target():
	_wander_target = Vector2(rand_range(-128,128), rand_range(-128,128)) + position

func drop_power_up():
	var drop = randi() % 100
	if drop < DROP_RATE:
		var powerup
		drop = randi() % 100
		print(drop)
		if drop < 60:
			powerup = healing_power_up.instance()
			powerup.heal_amount = (randi() % 21) + 10
		elif drop < 85:
			powerup = damage_power_up.instance()
		else:
			powerup = invincible_power_up.instance()
		powerup.position = position
		get_parent().add_child(powerup)

func _chase():
	var steering = _pursuit()
	velocity = _truncate(velocity + steering, speed)
	velocity = move_and_slide(velocity)
	rotation = velocity.angle()

func _avoid(target):
	var avoidance_force = Vector2.ZERO
	var space_state = get_world_2d().direct_space_state
	var _sight_check = space_state.intersect_ray(position, target, [self], 5) #Mm.. Hay cosas que no me cierran, debería revisar 1 o 2 pasos adelante (lo que se puede mover), no exactamente al punto al que pretende llegar..
	if _sight_check && _sight_check.collider:
		var collider_pos = _sight_check.collider.position
		var collision_pos = _sight_check.position
		avoidance_force = (collision_pos - collider_pos).normalized() * speed
		if _check_points_aligned(position, collision_pos, collider_pos):
			avoidance_force.rotate(PI/3)
	return avoidance_force

func _check_points_aligned(p0, p1, p2):
	var vec1 = p1 - p0
	var vec2 = p2 - p1
	if vec1.x == 0 || vec1.y == 0:
		return false
	return vec2.x/vec1.x == vec2.y / vec1.y

func _pursuit():
	var distance = _target.position - position
	var t:int = distance.length() / _target.speed
	var target = _target.position + _target.velocity * t
	return (((target - position).normalized() * speed) - velocity) + _avoid(target)

func _truncate(v, m):
	var i = m / v.length()
	i = min(i, 1.0)
	return v * i

func sight_check():
	if _target:
		if _target_in_attack_range:
			var space_state = get_world_2d().direct_space_state
			var _sight_check = space_state.intersect_ray(position, _target.position, [self], collision_mask)
			if _sight_check && _sight_check.collider.is_in_group("player"):
				_state = states.ATTACK
		else:
			_state = states.CHASE
	elif _target_on_seek_area:
		var space_state = get_world_2d().direct_space_state
		var _sight_check = space_state.intersect_ray(position, _target_on_seek_area.position, [self], collision_mask)
		if _sight_check && _sight_check.collider.is_in_group("player"):
			_target = _sight_check.collider
			$SeekArea.set_deferred("set_monitoring",false)
	else:
		_state = states.WANDER

func on_hit(damage, weapon, playerPosition):
	if !_target:
		_target = get_parent().get_node("Player")
	get_damage(damage)
	$HitTimer.start()
	if weapon._weapon_type == "mele":
		knockback(playerPosition)

func knockback(pushBack):
	velocity-= (pushBack - self.global_position).normalized() * 2800
	move_and_slide(velocity)

func hit_target(target, _weapon):
	if target.has_method("on_hit") && !target.is_in_group("enemies"):
		target.on_hit(weapon.weapon_damage * strength, global_position)

func randomNumberBetween(numberOne, numberTwo):
	rng.randomize()
	return rng.randi_range(numberOne, numberTwo)

func _shield_effect():
	if shield_effect != null:
			#Play sound effect
			var sfx = shield_effect.shield_sfx
			var numberSound = randomNumberBetween(0, 1)
			sfx.set_stream(sfx.sfx_list[numberSound])
			sfx.set_volume_db(-15.0)
			sfx.play()

			#Emmit particle
			shield_effect.shield_particle.position = position
			shield_effect.shield_particle.emitting = true

func get_damage(base_damage:int):
	var damage_left:int = base_damage
	sprite.material.set_shader_param("hp_color", Color.white)
	if _cur_armor > 0:
		_shield_effect()
		damage_left = max(base_damage - _cur_armor, 0)
		_cur_armor = max(_cur_armor - base_damage, 0)
		_update_armor_sprite()
	if damage_left > 0:
		blood_floor(0.28)
		$AudioPlayerHit.play()
		_cur_health -= damage_left

	_update_hp_shader()

func _on_SeekArea_body_entered(body):
	if _target == null && body.is_in_group("player"):
		_target_on_seek_area = body

func _on_SeekArea_body_exited(body):
	if body.is_in_group("player"):
		_target_on_seek_area = null

func target_in_range():
	_target_in_attack_range = true

func target_out_of_range():
	_target_in_attack_range = false

func _on_Hit_Timer_timeout():
	sprite.material.set_shader_param("hp_color", enemy_color)

func _update_hp_shader():
	var normalized_damage:float = 0.57 - (0.25*(float(_cur_health) -1.0) / (float(health) - 1.0))
	sprite.material.set_shader_param("damage", normalized_damage)

func _update_armor_sprite():
	var normalized_armor:float = float(_cur_armor) / float(armor) #Para que aparezcan siempre como si tuvieran una buena armadura, solo que se rompe más rápido en ciertos casos.
	var scaleFloat = 1.0 + (normalized_armor * 0.5)
	armor_sprite.scale = Vector2(scaleFloat, scaleFloat)
