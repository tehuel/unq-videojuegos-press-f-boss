extends KinematicBody2D

class_name BaseAI

export (int) var speed:int = 300
export (int) var hp:int = 3
export (int) var strength:int = 2
export (int) var armor:int = 0

onready var weapon = $Visual/Weapon

var _state = states.IDLE
var _target_in_attack_range = false
var _target_on_seek_area
var _navmap
var _target
var container

enum states {IDLE, ATTACK, CHASE}

func initialize(navmap, cont):
	_navmap = navmap
	container = cont

func _ready():
	weapon.take_weapon(self)

func _process(delta):
	match _state:
		states.IDLE:
			pass
		states.ATTACK:
			weapon.attack()
		states.CHASE:
			_chase(delta)

func _physics_process(_delta):
	sight_check()
	
	if hp <=0:
		queue_free()

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
	get_damage(damage)
	$Visual/HitTimer.start()

func hit_target(target):
	if target.has_method("on_hit"):
		target.on_hit(weapon.weapon_damage * strength)

func get_damage(base_damage):
	modulate = Color.white
	hp -= (base_damage - armor)

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
