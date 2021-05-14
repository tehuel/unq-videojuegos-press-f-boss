extends KinematicBody2D

export var speed = 400
var attacking:bool = false

onready var weaponPlayer = $WeaponPlayer
onready var animatedSprite = $AnimatedSprite
onready var rangedWeapon = $RangedWeapon
var projectile_container

func start(pos, sel):
	position = pos
	show()
	$CollisionShape2D.disabled = false
	initialize(sel)

func _ready():
	hide()

func initialize(projectile_container):
	self.projectile_container = projectile_container
	rangedWeapon.projectile_container = projectile_container

func _process(delta):
	var screen_size = get_viewport_rect().size
	var velocity = Vector2()
	velocity.x = int(Input.is_action_pressed("derecha")) - int(Input.is_action_pressed("izquierda"))
	velocity.y = int(Input.is_action_pressed("abajo")) - int(Input.is_action_pressed("arriba"))
	
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		animatedSprite.play()
	else:
		animatedSprite.stop()
		
	position += velocity * delta
	position.x = clamp(position.x, 0, 3600)
	position.y = clamp(position.y, 0, 3600)
	
	if velocity.x != 0:
		animatedSprite.animation = "walk"
		animatedSprite.flip_v = false
		animatedSprite.flip_h = velocity.x < 0
	elif velocity.y != 0:
		animatedSprite.animation = "up"
		animatedSprite.flip_v = velocity.y > 0
		
	if Input.is_action_pressed("left_click"):
		playerAttack()
		
	if Input.is_action_just_pressed("right_click"):
		if projectile_container == null:
			projectile_container = get_parent()
			rangedWeapon.projectile_container = projectile_container
		rangedWeapon.fire()

func on_hit(base_damage):
	print("damaged for: ", base_damage)

func playerAttack():
	if !attacking:
		attacking = true
		attacking = weaponPlayer.attack()
	
