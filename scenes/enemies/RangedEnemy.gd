extends BaseAI

onready var _pattern_shoots = (randi() % 2) + 3
onready var _wait_time = rand_range(1.3, 1.7)
onready var _telegraph_time = rand_range(0.3, 0.5)
var _wait_timer = null
var _pattern_ready = true
var _telegraph_timer = null
var telegraph_scene = load("res://scenes/utils/TelegraphAxe.tscn")
var _telegraph = null

func _ready():
	_wait_timer = Timer.new()
	_wait_timer.set_one_shot(true)
	_wait_timer.set_wait_time(_wait_time)
	_wait_timer.connect("timeout", self, "_on_timeout_complete")
	add_child(_wait_timer)
	_telegraph_timer = Timer.new()
	_telegraph_timer.set_one_shot(true)
	_telegraph_timer.set_wait_time(_telegraph_time)
	_telegraph_timer.connect("timeout", self, "_on_telegraph_complete")
	add_child(_telegraph_timer)
	._ready()

func _attack():
	if _pattern_ready:
		_pattern_ready = false
		_telegraph = telegraph_scene.instance()
		add_child(_telegraph)
		_telegraph_timer.start()

func _on_timeout_complete():
	_pattern_ready = true
	set_process(true)

func _on_telegraph_complete():
	_telegraph.queue_free()
	for _i in range(1, _pattern_shoots, 1):
			weapon.attack()
			yield(weapon, "attack_ready")
	set_process(false)
	_wait_timer.start()
