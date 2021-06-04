extends Area2D

export (int) var heal_amount:int = 25
onready var soundHeal = $AudioStreamPlayer

func _ready():
	$AnimationPlayer.play("AnimatedPowerUp")

func _on_PowerUp_body_entered(body):
	if body.is_in_group("player") && body.has_method("on_heal"):
		$CollisionShape2D.set_deferred("set_monitoring",false)
		body.on_heal(heal_amount)
		soundHeal.play()
		yield(soundHeal, "finished")
		call_deferred("queue_free")
