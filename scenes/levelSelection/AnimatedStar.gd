extends Sprite


func _ready():
	$AnimationPlayer.set_speed_scale(rand_range(0.01, 1.0))
