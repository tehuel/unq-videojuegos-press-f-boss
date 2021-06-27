extends Sprite

onready var blood_backGround = $AnimationPlayer

func _ready():
	var anim = get_node("AnimationPlayer").get_animation("Blink")
	anim.set_loop(true)
	blood_backGround.play("Blink")
