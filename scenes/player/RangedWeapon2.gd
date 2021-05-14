extends Sprite

onready var rangedWeaponPosition = $RangedWeaponPosition

export (PackedScene) var projectile_scene:PackedScene

var projectile_container
var proj_instance 

func fire():
	proj_instance = projectile_scene.instance()
	proj_instance.initialize(projectile_container, rangedWeaponPosition.global_position, global_position.direction_to(rangedWeaponPosition.global_position))


func add_collision_exception_to_projectile(object):
	proj_instance.add_
