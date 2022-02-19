extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	var n = Random.random.randi_range(1, 2)
	if n == 2:
		$Sprite.flip_h = true

	z_index = Random.random.randi_range(10, 15)
