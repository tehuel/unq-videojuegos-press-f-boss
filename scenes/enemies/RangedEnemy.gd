extends BaseAI

onready var _number_of_shoots_until_rest = (randi() % 4) + 2
onready var _wait_time = rand_range(1.3, 1.7)
var _wait_timer = null
var _pattern_ready = true
var _shoots = 0

func _ready():
	_wait_timer = Timer.new()
	_wait_timer.set_one_shot(true)
	_wait_timer.set_wait_time(_wait_time)
	_wait_timer.connect("timeout", self, "_on_timeout_complete")
	add_child(_wait_timer)
	._ready()

func attack():
	if _pattern_ready:
		if _shoots < _number_of_shoots_until_rest:
			if weapon.attack():
				_shoots += 1
		else:
			_pattern_ready = false
			_wait_timer.start()

func _on_timeout_complete():
	_shoots = 0
	_pattern_ready = true
