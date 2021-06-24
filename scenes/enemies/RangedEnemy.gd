extends BaseAI

onready var _number_of_shoots_until_rest = (randi() % 2) + 3
onready var _wait_time = rand_range(1.3, 1.7)
var _wait_timer = null
var _pattern_ready = true

func _ready():
	_wait_timer = Timer.new()
	_wait_timer.set_one_shot(true)
	_wait_timer.set_wait_time(_wait_time)
	_wait_timer.connect("timeout", self, "_on_timeout_complete")
	add_child(_wait_timer)
	._ready()

func attack():
	if _pattern_ready:
		for _i in range(1, _number_of_shoots_until_rest, 1):
			weapon.attack()
			yield(weapon, "attack_ready")
		_pattern_ready = false
		_wait_timer.start()
		set_process(false)

func _on_timeout_complete():
	_pattern_ready = true
	set_process(true)
