extends KinematicBody2D

export var speed = 400
export var health = 100

onready var melee_weapon = $MeleeWeapon
onready var ranged_weapon = $RangedWeapon
onready var dash_timer = $DashTimer
var container
var _cur_speed
var _cur_health
var _invincible = false

func start(pos, cont):
	position = pos
	show()
	$CollisionShape2D.disabled = false
	container = cont
	ranged_weapon.take_weapon(self)
	melee_weapon.take_weapon(self)
	_cur_speed = speed
	_cur_health = health

func _ready():
	hide()

func _physics_process(_delta):
	if !_invincible && _cur_health == 0:
		queue_free() #Meter algo interesante, no este queue_free()
	
	var velocity = Vector2()
	velocity.x = int(Input.is_action_pressed("derecha")) - int(Input.is_action_pressed("izquierda"))
	velocity.y = int(Input.is_action_pressed("abajo")) - int(Input.is_action_pressed("arriba"))
	
	if velocity.length() > 0:
		velocity = velocity.normalized()
	
	if Input.is_action_just_pressed("dash") && dash_timer.is_stopped():
		_cur_speed *= 2.5
		dash_timer.start()
		
	velocity = move_and_slide(velocity * _cur_speed)
	rotate(get_angle_to(get_global_mouse_position()))
	
	if Input.is_action_pressed("left_click"):
		melee_attack()
		
	if Input.is_action_just_pressed("right_click"):
		ranged_attack()

func on_hit(base_damage):
	if !_invincible:
		_cur_health -= base_damage
		_cur_health = clamp(_cur_health, 0, health)
	print("remaining health", _cur_health)

func on_heal(amount):
	_cur_health += amount
	_cur_health = clamp(_cur_health, 0, health)
	print("remaining health", _cur_health)

func melee_attack():
	melee_weapon.attack()

func ranged_attack():
	ranged_weapon.attack()
	
func hit_target(target, weapon):
	if target.has_method("on_hit"):
		target.on_hit(weapon.weapon_damage)

func _on_DashTimer_timeout():
	_cur_speed = speed

