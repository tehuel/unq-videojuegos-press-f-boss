extends Node

onready var outPutStreamSoundTrack = $SoundTrack
var pause = false

var rng = RandomNumberGenerator.new()

func randomNumberBetween(numberOne, numberTwo):
	rng.randomize()
	return rng.randi_range(numberOne, numberTwo)

func playSoundTrack():
	var numberSound = randomNumberBetween(0, 1)
	outPutStreamSoundTrack.set_stream(outPutStreamSoundTrack.soundTracksLevel[numberSound])
	outPutStreamSoundTrack.set_volume_db(-20.0)
	outPutStreamSoundTrack.play()

func _ready():
	$MapGenerator.generate_random_map()
	$Player.start($StartPosition.position, self)
	playSoundTrack()
	$BloodBackGroundCanvas.bloodSprite.visible = false

func _on_Player_bloodBackgroundSignal(value):
	$BloodBackGroundCanvas.bloodSprite.visible = value
