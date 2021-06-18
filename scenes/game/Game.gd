extends Node

onready var damage_text = load("res://scenes/utils/DamageText.tscn")

func _ready():
	$MapGenerator.generate_random_map()
	$Player.start($StartPosition.position, self)
	$Soundtrack.play()

#func _process(_delta):
#	if Input.is_action_just_pressed("_debug_pass_map"):
#		Game.set_current_level(Game.level + 1)
## warning-ignore:return_value_discarded
#		get_tree().change_scene("res://scenes/levelSelection/LevelSelection.tscn")

# dibujo texto flotante, con posicion relativa al game
func draw_text(value, color, position):
	var text = damage_text.instance()
	add_child(text)
	text.text = value
	text.get_font("font").set_outline_color(color)
	text.rect_position = position
