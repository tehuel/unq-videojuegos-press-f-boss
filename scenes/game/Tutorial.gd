extends TileMap

onready var enemyAudioDie = $AudioDie
onready var portal = $Portal
onready var outPutStreamSoundTrack = $SoundTrack

var pause = false
var enemiesLeft = 2

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
	playSoundTrack()
	$BloodBackGroundCanvas.bloodSprite.visible = false
	Game.set_current_level(0)
	$Player.start($StartPosition.position, self)
	portal.enable_first()
	portal.enable_second()
	portal.enable_third()
	portal.enable_fourth()
	$MeleeEnemy.initialize(self, $AudioDie)
	$RangedEnemy.initialize(self, $AudioDie)
	
func _input(event):
	if event.is_action_pressed("ui_cancel") && !pause:
		Game.set_current_level(Game.level + 1)
		get_tree().change_scene("res://scenes/levelSelection/LevelSelection.tscn")

func _on_enemy_died():
	enemiesLeft -= 1
	if !enemiesLeft:
		portal.enable_last()

func _on_Player_bloodBackgroundSignal(value):
	$BloodBackGroundCanvas.bloodSprite.visible = value


func _on_Arearclick_body_entered(_body):
	$Arearclick/Rclick.visible = true
	$Arearclick/AtaqueRango.visible = true


func _on_Arealclick_body_entered(_body):
	$Arealclick/Lclick.visible = true
	$Arealclick/AtaqueMele.visible = true


func _on_Areaspacebar_body_entered(_body):
	$Areaspacebar/Spacebar.visible = true
	$Areaspacebar/Dash.visible = true


func _on_Areawasd_body_entered(_body):
	$Areawasd/Wasd.visible = true
	$Areawasd/Movimiento.visible = true


func _on_Areawasd_body_exited(_body):
	$Areawasd/Wasd.visible = false
	$Areawasd/Movimiento.visible = false


func _on_Areaspacebar_body_exited(_body):
	$Areaspacebar/Spacebar.visible = false
	$Areaspacebar/Dash.visible = false


func _on_Arealclick_body_exited(_body):
	$Arealclick/Lclick.visible = false
	$Arealclick/AtaqueMele.visible = false


func _on_Arearclick_body_exited(_body):
	$Arearclick/Rclick.visible = false
	$Arearclick/AtaqueRango.visible = false
