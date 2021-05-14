extends KinematicBody2D

export var speed = 400

onready var melee_weapon = $MeleeWeapon
onready var ranged_weapon = $RangedWeapon
var container
var _cur_speed

func start(pos, cont):
	position = pos
	show()
	$CollisionShape2D.disabled = false
	container = cont
	ranged_weapon.take_weapon(self)
	melee_weapon.take_weapon(self)
	_cur_speed = speed

func _ready():
	hide()

func _physics_process(_delta):
	var velocity = Vector2()
	velocity.x = int(Input.is_action_pressed("derecha")) - int(Input.is_action_pressed("izquierda"))
	velocity.y = int(Input.is_action_pressed("abajo")) - int(Input.is_action_pressed("arriba"))
	
	if velocity.length() > 0:
		velocity = velocity.normalized()
	
	if Input.is_action_just_pressed("dash"):
		_cur_speed *= 2.5
		$DashTimer.start()
		
	velocity = move_and_slide(velocity * _cur_speed)
	rotate(get_angle_to(get_global_mouse_position()))
	
	if Input.is_action_pressed("left_click"):
		melee_attack()
		
	if Input.is_action_just_pressed("right_click"):
		ranged_attack()

func on_hit(base_damage):
	print("damaged for: ", base_damage)

func melee_attack():
	melee_weapon.attack()

func ranged_attack():
	ranged_weapon.attack()
	
func hit_target(target, weapon):
	if target.has_method("on_hit"):
		target.on_hit(weapon.weapon_damage)


func _on_DashTimer_timeout():
	_cur_speed = speed
