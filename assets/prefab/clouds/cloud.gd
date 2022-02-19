extends Sprite

var uniqueVel = 0
var height = 0

func _ready():
	var num = Random.random.randi_range(20, 60)
	uniqueVel = num
	
func _process(delta):
	self.position.x -= uniqueVel * delta
