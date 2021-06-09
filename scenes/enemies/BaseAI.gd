extends KinematicBody2D

class_name BaseAI

export (int) var speed:int = 300
export (int) var health:int = 3
export (int) var strength:int = 2
export (int) var armor:int = 0

onready var weapon = $Visual/Weapon
onready var damage_text = load("res://scenes/utils/DamageText.tscn")
onready var healing_power_up = preload("res://scenes/environment/HealingPowerUp.tscn")
onready var invincible_power_up = preload("res://scenes/environment/InvincibilityPowerUp.tscn")
onready var damage_power_up = preload("res://scenes/environment/StrengthPowerUp.tscn")
onready var sprite = $Visual/Sprite
onready var armor_sprite = $Visual/Sprite/Sprite2

var _cur_health
var _state = states.IDLE
var _target_in_attack_range = false
var _target_on_seek_area
var _navmap
var _target
var container
var _dieSound

enum states {IDLE, ATTACK, CHASE}

const DROP_RATE = 35 # % / 100

signal enemy_died

func initialize(navmap, cont, dieSound):
	_navmap = navmap
	container = cont
	_dieSound = dieSound
	randomize()

func _ready():
	_cur_health = health
	sprite.material.set_shader_param("hp_color", sprite.modulate)
	sprite.material.set_shader_param("damage_color", Color("8b0000"))
	weapon.take_weapon(self)
	_update_hp_shader()
	_update_armor_sprite()

func _process(delta):
	match _state:
		states.IDLE:
			pass
		states.ATTACK:
			attack()
		states.CHASE:
			_chase(delta)

func _physics_process(_delta):
	sight_check()
	
	if _cur_health <=0:
		emit_signal("enemy_died")
		drop_power_up()
		if(_dieSound != null):
			_dieSound.play()
		queue_free()
	
func attack():
	weapon.attack()
	
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
	
func _chase(delta):
	var path_to_dest = _navmap.get_simple_path(position, _target.position, false)
	var starting_point = position
	var move_distance = speed * delta
	for _point in range(path_to_dest.size()):
		var distance_to_next_point = starting_point.distance_to(path_to_dest[0])
		if move_distance > 0 && move_distance <= distance_to_next_point:
			$Visual.rotation = (_target.position - position).angle()
			var move_rotation = get_angle_to(starting_point.linear_interpolate(path_to_dest[0], move_distance / distance_to_next_point))
			var motion = Vector2(speed, 0).rotated(move_rotation)
			motion = move_and_slide(motion)
			break
		move_distance -= distance_to_next_point
		starting_point = path_to_dest[0]
		path_to_dest.remove(0)

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
			$Visual/SeekArea.set_deferred("set_monitoring",false)
	else:
		_state = states.IDLE

func on_hit(damage):
	if !_target:
		_target = get_parent().get_node("Player")
	get_damage(damage)
	$Visual/HitTimer.start()

func hit_target(target, _weapon):
	if target.has_method("on_hit") && !target.is_in_group("enemies"):
		target.on_hit(weapon.weapon_damage * strength)

func get_damage(base_damage:int):
	var damage_left:int = base_damage
	sprite.material.set_shader_param("hp_color", Color.white)
	if armor > 0:
# warning-ignore:narrowing_conversion
		damage_left = max(base_damage - armor, 0)
# warning-ignore:narrowing_conversion
		armor = max(armor - base_damage, 0)
		_update_armor_sprite()
	if damage_left > 0:
		_cur_health -= damage_left
	var text = damage_text.instance()
	text.text = '-' + str(base_damage)
	text.get_font("font").set_outline_color(Color(0.6, 0, 0, 1))
	add_child(text)
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
	sprite.material.set_shader_param("hp_color", sprite.modulate)
	
func _update_hp_shader():
	var normalized_damage:float = 0.57 - (0.25*(float(_cur_health) -1.0) / (float(health) - 1.0))
	sprite.material.set_shader_param("damage", normalized_damage)
	
func _update_armor_sprite():
	var normalized_armor:float = float(armor) / 100.0 #100 = max armor (?)
	var scaleFloat = 1.0 + (normalized_armor * 0.5)
	armor_sprite.scale = Vector2(scaleFloat, scaleFloat)
