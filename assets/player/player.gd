extends KinematicBody2D

onready var flare = get_node("flare")
onready var timer = get_node("Timer")
onready var timerAnim = get_node("shootAnim")
onready var sprite = get_node("sprite")

var XVel = 200;
var gravity = 1280 # 1200
var velocity = Vector2(XVel, gravity)
var canShoot = true
var currentJumps = 0
var maxJumps = 2
var isJumping = false

func jumping(event):
	if event.is_action_pressed("jump"):
		if !is_on_floor() and currentJumps < maxJumps:
			velocity.y = -10 * 60
			currentJumps += 1
			sprite.animation = "jumping"
			isJumping = true

func shoot(event):
	if event.is_action_pressed("shoot") and canShoot:
		canShoot = false
		sprite.animation = "shooting"
		flare.visible = true
		timerAnim.start()
		timer.start()
		# Adds the bullet
		var bullet = preload("res://assets/prefab/projectiles/bullet.tscn").instance()
		bullet.position.x = self.position.x + 30
		bullet.position.y = self.position.y + 6
		get_tree().get_root().add_child(bullet)
	if event.is_action_released("shoot"):
		if isJumping:
			sprite.animation = "jumping"
		else:
			sprite.animation = "running"

func _input(event):
	jumping(event)
	shoot(event)

func _physics_process(delta):
	velocity.x = (XVel * 70) * delta
	velocity.y += gravity * delta
	velocity = move_and_slide(velocity, Vector2(0, 0))
	# Updates the player pos
	Player.actualPlayerPos = velocity
	Gplayer.PlayerActualPos = self.position
	if self.position.y > 850:
		get_tree().reload_current_scene()


func _on_Timer_timeout():
	flare.visible = false


func _on_Area2D_body_entered(body):
	if body.is_in_group("platforms"):
		currentJumps = 0
		sprite.animation = "walking"
		isJumping = false


func _on_Area2D_body_exited(body):
	pass # Replace with function body.


func _on_shootAnim_timeout():
	sprite.animation = "walking"
	canShoot = true


func _on_speed_timeout():
	if XVel <= 600:
		XVel += 2
		print("xvel", XVel)
