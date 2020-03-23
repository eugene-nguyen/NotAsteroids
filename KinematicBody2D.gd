extends KinematicBody2D
# This script controls movement.

var motion = Vector2()
var speed = 0
var angle = 0

var speed_accel = 5
var angle_accel = 1
var min_speed = -500
var max_speed = 500
var max_angle = 2 * PI

func _physics_process(delta):
	if Input.is_action_pressed("ui_up"):
		speed = min(speed_accel + speed, max_speed)
	elif Input.is_action_pressed("ui_down"):
		speed = max(speed_accel - speed, min_speed)
	else:
		while (speed > 0):
			speed -= speed_accel
		while (speed < 0):
			speed += speed_accel
			
	
	if Input.is_action_pressed("ui_left"):
		angle -= angle_accel
	elif Input.is_action_pressed("ui_right"):
		angle += angle_accel
	
	angle = angle % 360
	
	motion.x = speed * cos(angle)
	motion.y = speed * sin(angle)
	
	print(speed)
	print(angle)
	
	move_and_slide(motion)
