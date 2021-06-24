extends KinematicBody2D

export var speed = 400
export var health = 100
export var strength = 1
export(PackedScene) var dash_object

onready var melee_weapon = $MeleeWeapon
onready var ranged_weapon = $RangedWeapon
onready var dash_timer = $DashTimer
onready var slow_motion_timer = $SlowMotion
onready var sprite = $Sprite

var velocity = Vector2.ZERO
var container
var _cur_speed
var _cur_health
var _invincible = false
var slowMotionActive = false

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
	Engine.set_time_scale(1)
	hide()

func _physics_process(_delta):
	if !_invincible && _cur_health == 0:
		print("mission failed")
		# warning-ignore:return_value_discarded
		get_tree().change_scene("res://scenes/theEnd/youDie.tscn") #Meter algo interesante..
	
	velocity.x = int(Input.is_action_pressed("derecha")) - int(Input.is_action_pressed("izquierda"))
	velocity.y = int(Input.is_action_pressed("abajo")) - int(Input.is_action_pressed("arriba"))
	
	if velocity.length() > 0:
		velocity = velocity.normalized()
	
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

func on_hit(base_damage):
	var textValue
	var textColor
	if !_invincible:
		$AudioPlayerHit.play()
		_cur_health -= base_damage
		_cur_health = clamp(_cur_health, 0, health)
		textValue = "-" + str(base_damage)
		textColor = Color(0.6, 0, 0, 1)
	else:
		textValue = '0'
		textColor = Color(0, 0, 0, 0.2)
	
	get_parent().draw_text(textValue, textColor, position)
	_update_hp_shader()
	print("remaining health", _cur_health)

func on_heal(amount):
	_cur_health += amount
	_cur_health = clamp(_cur_health, 0, health)

	var textValue = '+' + str(amount)
	var textColor = Color(0, 0.8, 0, 1)
	get_parent().draw_text(textValue, textColor, position)
	_update_hp_shader()
	print("remaining health", _cur_health)
	
func _update_hp_shader():
	var normalized_damage:float = 0.57 - (0.25*(float(_cur_health) -1.0) / (float(health) - 1.0))
	sprite.material.set_shader_param("damage", normalized_damage)

func melee_attack():
	melee_weapon.attack()

func ranged_attack():
	ranged_weapon.attack()
	
func hit_target(target, weapon):
	if target.has_method("on_hit"):
		$AudioPlayerHit.play()
		slowMotion()
		target.on_hit(weapon.weapon_damage * strength)

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
