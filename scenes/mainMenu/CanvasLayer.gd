extends CanvasLayer

export var isVisible = true
onready var control = $Control


func _ready():
	control.visible = isVisible
