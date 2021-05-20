tool
extends AnimatedSprite

export (float, 0.0, 1.0) var r = 1 setget _set_r
export (float, 0.0, 1.0) var g = 1 setget _set_g
export (float, 0.0, 1.0) var b = 1 setget _set_b
export (float, 0.0, 1.0) var armor = 1 setget _set_armor
export (int, 5) var sides = 1 setget _set_sides


func _set_r(new_r):
	r = new_r
	_set_color()
	
func _set_g(new_g):
	g = new_g
	_set_color()
	
func _set_b(new_b):
	b = new_b
	_set_color()

func _set_armor(new_armor):
	armor = new_armor
	var scaleFloat = 1.0 + (new_armor * 0.5)
	$InnerPolygon.scale = Vector2(scaleFloat, scaleFloat)

func _set_sides(new_sides):
	sides = new_sides
	self.frame = new_sides
	$InnerPolygon.frame = new_sides
	
func _ready():
	_set_color()

func _set_color():
	self.modulate = Color(_clamp_color(r), _clamp_color(g), _clamp_color(b))
	
func _clamp_color(c):
	return clamp((0.5 * c) + 0.25, 0, 1)
