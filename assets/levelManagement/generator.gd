extends Node2D

# Needs to be equal to the lasts tile (x position)
var xPos = 1040

var gap = false
var gapSize = 0
var actualGapSize = 0

# True if needs to add decorations
var decoration = false
var flora

# Clouds below
onready var cloud1 = preload("res://assets/prefab/clouds/cloud.tscn")

# Tiles below
onready var grassFlat = preload("res://assets/prefab/tiles/grass2.tscn")
onready var grassFlatDots = preload("res://assets/prefab/tiles/grass5.tscn")

onready var grassD1 = preload("res://assets/prefab/tiles/grass1.tscn")
onready var grassD2 = preload("res://assets/prefab/tiles/grass3.tscn")
onready var grassD3 = preload("res://assets/prefab/tiles/grass4.tscn")

onready var corner = preload("res://assets/prefab/tiles/corner3.tscn")
onready var corner1 = preload("res://assets/prefab/tiles/corner4.tscn")

onready var cornerDots = preload("res://assets/prefab/tiles/corner1.tscn")
onready var cornerDots1 = preload("res://assets/prefab/tiles/corner2.tscn")

onready var cornerLeaves = preload("res://assets/prefab/tiles/cornerLeaves1.tscn")
onready var cornerLeaves1 = preload("res://assets/prefab/tiles/cornerLeaves.tscn")

onready var voidTile = preload("res://assets/prefab/tiles/void.tscn")

func _ready():
	var num = Random.random.randi_range(2, 4)
	gapSize = num

func _on_Area2D_body_exited(body):
	
	xPos += 80
	var tile
	
	var num = Random.random.randi_range(1, 10)
	
	if gap:
		print("actual gap size: ", actualGapSize)
		if actualGapSize <= gapSize:
			tile = voidTile.instance()
		elif actualGapSize > gapSize:
			gap = false
			num = Random.random.randi_range(1, 3)
			if num == 1:
				tile = corner.instance()
			elif num == 2:
				tile = cornerDots.instance()
			else:
				tile = cornerLeaves.instance()
		actualGapSize += 1
	else:
		if num >= 1 and num <= 5:  # Primary flat grass tile
			tile = grassFlat.instance()
		elif num >= 6 and num <= 8:  # Adds one of the three details
			num = Random.random.randi_range(1, 3)
			if num == 1:
				tile = grassD1.instance()
			elif num == 2:
				tile = grassD2.instance()
			else:
				tile = grassD3.instance()

		elif num == 9:  # Adds dots tiles
			tile = grassFlatDots.instance()
		else:  # Creates a new gap and adds the corner
			gapSize = Random.random.randi_range(2, 4)
			actualGapSize = 0
			gap = true
			# Decides the type of corner
			num = Random.random.randi_range(1, 6)
			
			if num >= 1 and num <= 4:
				tile = corner1.instance()
			elif num == 5:
				tile = cornerDots1.instance()
			else:
				tile = cornerLeaves1.instance()
		
		# Calculates a chance to add decorations(flora) on the tile
		num = Random.random.randi_range(1, 70)
		# Trees spawn below
		if num >= 1 and num <= 2:
			flora = load("res://assets/prefab/flora/trees/Tree3.tscn").instance()
			decoration = true
		elif num >= 3 and num <= 4:
			flora = load("res://assets/prefab/flora/trees/Tree2.tscn").instance()
			decoration = true
		elif num >= 5 and num <= 12:
			flora = load("res://assets/prefab/flora/trees/Tree1.tscn").instance()
			decoration = true
		# Grass, Flora spawn below
		elif num >= 13 and num <= 17:
			flora = load("res://assets/prefab/flora/mini/Grass1.tscn").instance()
			decoration = true
		elif num >= 18 and num <= 22:
			flora = load("res://assets/prefab/flora/mini/Grass2.tscn").instance()
			decoration = true
		elif num >= 23 and num <= 26:
			flora = load("res://assets/prefab/flora/mini/Flower1.tscn").instance()
			decoration = true
		elif num >= 27 and num <= 30:
			flora = load("res://assets/prefab/flora/mini/Flower2.tscn").instance()
			decoration = true

		#### Flips the tile
		num = Random.random.randi_range(1, 3)
		if num == 3 and !gap:
			tile.get_node("Sprite").flip_h = true
	
	tile.position.x = xPos
	tile.position.y = 540
	get_tree().get_root().add_child(tile)
	
	if decoration:
		flora.position.x = xPos
		flora.position.y = 509
		get_tree().get_root().add_child(flora)
		
		decoration = false


#  Generates the clouds
func _on_cloudsTimer_timeout():
	
	var num = Random.random.randi_range(1, 10)
	
	if num >= 1 and num <= 3:
		var cloud = cloud1.instance()
		
		cloud.position.x = Gplayer.PlayerActualPos.x + 1000
		
		num = Random.random.randi_range(60, 225)
		cloud.position.y = num
		
		get_tree().get_root().add_child(cloud)
