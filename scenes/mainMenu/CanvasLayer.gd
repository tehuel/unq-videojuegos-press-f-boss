extends CanvasLayer

export var isVisible = true
export var isInputValid = true
onready var control = $Control


func _ready():
	control.visible = isVisible
	control.isInputValid = isInputValid
	
func openControls():
	$Control.openControls()
