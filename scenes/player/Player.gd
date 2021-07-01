extends KinematicBody2D

export var speed = 400
export var health = 100
export var strength = 1
export(PackedScene) var dash_object

signal bloodBackgroundSignal(value)

onready var melee_weapon = $MeleeWeapon
onready var ranged_weapon = $RangedWeapon
onready var dash_timer = $DashTimer
onready var slow_motion_timer = $SlowMotion
onready var sprite = $Sprite
onready var invi = $InvincibleEffect
onready var power = $PowerEffect


var velocity = Vector2.ZERO
var container
var _cur_speed
var _cur_health
var _invincible = false
var slowMotionActive = false
var blood = load("res://scenes/utils/blood.tscn")
var invincibilityEffect = load("res://scenes/powerUpsEffect/invincibilityEffect.tscn")
var powerEffect = load("res://scenes/powerUpsEffect/powerEffect.tscn")

func start(pos, cont):
	position = pos
	show()
	$CollisionShape2D.disabled = false
	container = cont
	ranged_weapon.take_weapon(self)
	melee_weapon.take_weapon(self)
	_cur_speed = speed
	_cur_health = health
	sprite.material.set_shader_param("hp_color", "000000")
	sprite.material.set_shader_param("damage_color", Color("8b0000"))
	_update_hp_shader()

func _ready():
	print("Ready set Engine time scale to 1")
	Game.player_position = self
	Engine.set_time_scale(1)
	hide()

func _exit_tree():
	Game.player_position = null

func _physics_process(_delta):
	if _cur_health <= health * 0.35:
		emit_signal("bloodBackgroundSignal", true)
	else:
		emit_signal("bloodBackgroundSignal", false)

	if !_invincible && _cur_health == 0:
		print("mission failed")
		# warning-ignore:return_value_discarded
		get_tree().change_scene("res://scenes/theEnd/youDie.tscn") #Meter algo interesante..

	velocity.x = int(Input.is_action_pressed("derecha")) - int(Input.is_action_pressed("izquierda"))
	velocity.y = int(Input.is_action_pressed("abajo")) - int(Input.is_action_pressed("arriba"))

	if velocity.length() > 0:
		set_scale(Vector2(1.3,1.3))
		velocity = velocity.normalized()
	else:
		set_scale(Vector2(1.5,1.5))

	if Input.is_action_just_pressed("dash") && dash_timer.is_stopped():
		$AudioStreamPlayerDash.play()
		_cur_speed *= 2.5
		dash_timer.start()

		var dash_node = dash_object.instance()
		dash_node.texture = sprite.texture
		dash_node.global_position = global_position
		get_parent().add_child(dash_node)

	velocity = move_and_slide(velocity * _cur_speed)
	rotate(get_angle_to(get_global_mouse_position()))

	if Input.is_action_pressed("left_click"):
		melee_attack()

	if Input.is_action_just_pressed("right_click"):
		ranged_attack()

func on_hit(base_damage, playerPosition):
	if !_invincible:
		$AudioPlayerHit.play()
		blood_floor(0.6)
		_cur_health -= base_damage
		_cur_health = clamp(_cur_health, 0, health)
		#if weapon._weapon_type == "mele":
		knockback(playerPosition)
	_update_hp_shader()
	print("remaining health", _cur_health)

func blood_floor(scale = 1):
	var blood_instance : CPUParticles2D = blood.instance()
	blood_instance.scale = Vector2(scale, scale)
	get_tree().current_scene.add_child(blood_instance)
	blood_instance.global_position = global_position
	blood_instance.rotation = global_position.angle_to_point(Game.player_position.global_position)

func knockback(pushBack):
	velocity-= (pushBack - self.global_position).normalized() * 2800
	move_and_slide(velocity)

func on_heal(amount):
	_cur_health += amount
	_cur_health = clamp(_cur_health, 0, health)
	_update_hp_shader()
	print("remaining health", _cur_health)

func on_invincibility(isEffectOn):
	invi.visible = isEffectOn;

func on_power(isEffectOn):
	power.visible = isEffectOn;

func _update_hp_shader():
	var normalized_damage:float = 0.57 - (0.25*(float(_cur_health) -1.0) / (float(health) - 1.0))
	sprite.material.set_shader_param("damage", normalized_damage)

func melee_attack():
	melee_weapon.attack()

func ranged_attack():
	ranged_weapon.attack()

func hit_target(target, weapon):
	if target.has_method("on_hit") and target != self:
		target.on_hit(weapon.weapon_damage * strength, weapon, global_position)
		if weapon._weapon_type == "mele":
			$Camera2D.shake(8, 0.15, 0)
			slowMotion()

func slowMotion():
	if !slowMotionActive:
		slow_motion_timer.start()
		slowMotionActive = true
		Engine.set_time_scale(0.65)

func _on_DashTimer_timeout():
	_cur_speed = speed

func _on_SlowMotion_timeout():
	Engine.set_time_scale(1)
	slowMotionActive = false
