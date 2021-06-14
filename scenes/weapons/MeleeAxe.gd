extends Node2D

const sounds = [
	preload("res://assets/audio/weapon/swing1.mp3"),
	preload("res://assets/audio/weapon/swing2.mp3"),
	preload("res://assets/audio/weapon/swing3.mp3"),
	preload("res://assets/audio/weapon/swing4.mp3"),
	preload("res://assets/audio/weapon/swing5.mp3"),
]

func _process(_delta):
	if (Input.is_action_just_pressed("left_click")):
		$AnimationPlayer.play("swing")

func play():
	var selectedAudio = sounds[randi() % sounds.size()]
	$audio.stream = selectedAudio
	$audio.play();
