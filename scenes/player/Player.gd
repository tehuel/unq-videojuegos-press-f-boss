extends KinematicBody2D

export var speed = 400
export var health = 100
export var strength = 1

onready var melee_weapon = $MeleeWeapon
onready var ranged_weapon = $RangedWeapon
onready var dash_timer = $DashTimer
onready var damage_text = load("res://scenes/utils/DamageText.tscn")

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
		print("mission failed")
		get_tree().change_scene("res://scenes/levelSelection/LevelSelection.tscn") #Meter algo interesante..
	
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
	var text = damage_text.instance()
	text.text = '-'
	if !_invincible:
		_cur_health -= base_damage
		_cur_health = clamp(_cur_health, 0, health)
		text.text += str(base_damage)
		text.get_font("font").set_outline_color(Color(0.6, 0, 0, 1))
	else:
		text.text += '0'
		text.get_font("font").set_outline_color(Color(0, 0, 0, 0.2))
	add_child(text)
	print("remaining health", _cur_health)

func on_heal(amount):
	_cur_health += amount
	_cur_health = clamp(_cur_health, 0, health)
	var text = damage_text.instance()
	text.text = '+' + str(amount)
	text.get_font("font").set_outline_color(Color(0, 0.8, 0, 1))
	add_child(text)
	print("remaining health", _cur_health)

func melee_attack():
	melee_weapon.attack()

func ranged_attack():
	ranged_weapon.attack()
	
func hit_target(target, weapon):
	if target.has_method("on_hit"):
		target.on_hit(weapon.weapon_damage * strength)

func _on_DashTimer_timeout():
	_cur_speed = speed

