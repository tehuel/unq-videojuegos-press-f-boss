extends TileMap

func _ready():
	$Player.start($StartPosition.position, self)
