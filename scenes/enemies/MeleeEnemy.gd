extends BaseAI

func _on_Hit_Timer_timeout():
	$Visual/Sprite.modulate = Color("c90000")
