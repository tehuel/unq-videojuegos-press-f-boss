extends RichTextLabel

onready var camera = get_node("../../CameraMainMenu")
onready var sfx_dialog = $Dialog

var dialog = [
	"[wave amp=50 freq=2][center]Presiona [color=blue]Click Izquierdo[/color] para continuar...[/center][/wave]",
	"Bienvenido Cuivi...",
	"Hace cientos de polígonos atrás Odín, el dios de la sabiduría, la guerra y la muerte llamó a las armas a los Aesir para combatir en la batalla del fin del mundo, también conocida como Ragnarök.",
	"Esta encarnizada lucha contra los gigantes de fuego liderados por Surt, soberano de Muspelheim, aún continúa activa. Y se han unido los Jotun, liderados por Loki.",
	"Las fuerzas de Odín están siendo debilitadas, por lo que se está llamando a las armas a todo guerrero capaz de atravesar [shake rate=15 level=15][color=red]las tres islas[/color][/shake]...",
	"Estas islas están repletas de almas en pena que deberás [shake rate=10 level=10][color=red]eliminar[/color][/shake] para lograr activar el portal a la siguiente isla con aun más almas.",
	"Solo quienes logren superar este reto, podran entrar al Valhalla para ayudar a Odín y los Aesir a vencer en el Ragnarök.",
	"Buena suerte...",
	""]
var page = 0
var last_page = dialog.size() - 1

# Functions
func _ready():
	set_process_input(true)
	set_bbcode(dialog[page])
	set_visible_characters(0)

func _input(_event):
	if Input.is_action_just_pressed("left_click") and camera.position.y == -6700:
		if get_visible_characters() > get_total_character_count():
			if page < dialog.size()-1:
				page += 1
				set_bbcode(dialog[page])
				set_visible_characters(0)
				sfx_dialog.play()

		if page == last_page:
# warning-ignore:return_value_discarded
			get_tree().change_scene("res://scenes/game/Tutorial.tscn")

		else:
			set_visible_characters(get_total_character_count())
			sfx_dialog.stop()

	if Input.is_action_just_pressed("ui_cancel") and camera.position.y == -6700:
# warning-ignore:return_value_discarded
		get_tree().change_scene("res://scenes/game/Tutorial.tscn")

func _on_Timer_timeout():
	set_visible_characters(get_visible_characters()+1)

	if get_visible_characters() == get_total_character_count():
			sfx_dialog.stop()
