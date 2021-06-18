class_name BaseWeapon

extends Area2D

export (int) var weapon_damage:int = 1
export (float) var delay:float = 1

var _can_attack = true
var _timer = null
var _holder

func take_weapon(holder):
	_holder = holder

func _ready():
	_timer = Timer.new()
	_timer.set_one_shot(true)
	_timer.set_wait_time(delay)
	_timer.connect("timeout", self, "_on_timeout_complete")
	add_child(_timer)
	_timer.start()

func attack():
	pass

func _on_timeout_complete():
	_can_attack = true
	if (is_instance_valid(_holder) && _holder.has_method("weapon_ready")):
		_holder.weapon_ready()

func hit(body):
	_holder.hit_target(body, self)

func _target_in_range():
	if _holder && _holder.has_method("target_in_range"):
		_holder.target_in_range()

func _target_out_of_range():
	if _holder && _holder.has_method("target_out_of_range"):
		_holder.target_out_of_range()
