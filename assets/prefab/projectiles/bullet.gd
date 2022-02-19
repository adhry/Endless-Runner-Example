extends KinematicBody2D


export(int) var vel = 48000
var velocity = Vector2(vel, 0)

func _physics_process(delta):
	move_and_slide(velocity * delta)
