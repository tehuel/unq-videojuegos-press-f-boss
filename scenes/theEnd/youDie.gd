extends Node2D

onready var audio_player_die = $AudioPlayerDie

var rng = RandomNumberGenerator.new()

func _ready():
	var numberSound = randomNumberBetween(0, 2)
	audio_player_die.set_stream(audio_player_die.player_die[numberSound])
	audio_player_die.set_volume_db(-10.0)
	audio_player_die.play()
#	yield(audio_player_die, "finished")
# warning-ignore:return_value_discarded

func _process(_delta):
	var inputEnter = Input.is_action_just_pressed("ui_accept") || Input.is_action_just_pressed("left_click") || Input.is_action_just_pressed("ui_cancel")


	if (inputEnter):	
		# entro al level cuando termina la animacion
		if (!$AnimationPlayer.is_playing()):
			Game.set_current_level(1)
			get_tree().change_scene("res://scenes/mainMenu/MainMenu.tscn")

		# acelero la animacion 
		else:
			$AnimationPlayer.playback_speed = $AnimationPlayer.playback_speed * 1.5


func randomNumberBetween(numberOne, numberTwo):
	rng.randomize()
	return rng.randi_range(numberOne, numberTwo)
