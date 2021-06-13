extends RichTextLabel

onready var camera = get_node("../../CameraMainMenu")
onready var sfx_dialog = $Dialog

var dialog = [
	"[wave amp=50 freq=2][center]Preciona [color=blue]Click Izquierdo[/color] para continuar...[/center][/wave]",
	"Esta es la historia de Cuvikingo que quiere llegar al Valhalla...",
	"La unica forma de llegar al Valhalla es logrando atravezar las [color=red]tres islas[/color]...",
	"Una vez dentro de la isla tienes que [color=red]matar a todos los enemigos[/color] y de esa forma se abrira el portal a la siguiente isla con aun más enemigos...",
	"Buena suerte...",
	""]
var page = 0
var last_page = dialog.size() - 1

# Functions
func _ready():
	set_process_input(true)
	set_bbcode(dialog[page])
	set_visible_characters(0)

func _input(event):
	if Input.is_action_pressed("left_click") and camera.position.y == -6700:
		if get_visible_characters() > get_total_character_count():
			if page < dialog.size()-1:
				page += 1
				set_bbcode(dialog[page])
				set_visible_characters(0)
				sfx_dialog.play()
						
		if page == last_page:
			get_tree().change_scene("res://scenes/levelSelection/LevelSelection.tscn")

		else:
			set_visible_characters(get_total_character_count())
			sfx_dialog.stop()

func _on_Timer_timeout():
	set_visible_characters(get_visible_characters()+1)
	
	if get_visible_characters() == get_total_character_count():
			sfx_dialog.stop()
