extends KinematicBody2D

export (int) var turn_speed = 180
export (int) var move_speed = 150
export (float) var acceleration = 0.05
export (float) var deceleration = 0.025

var motion = Vector2(0, 0)
var Bullet = preload("res://Bullet.tscn")

var screen_size
var screen_buffer = 8

func get_input(delta, move_direction):
	if Input.is_action_pressed("ui_left"):
		rotation_degrees -= turn_speed * delta
	elif Input.is_action_pressed("ui_right"):
		rotation_degrees += turn_speed * delta
	
	if Input.is_action_pressed("ui_up"):
		motion = motion.linear_interpolate(move_direction, acceleration)
	else:
		motion = motion.linear_interpolate(Vector2(0, 0), deceleration)
	
	if Input.is_action_just_pressed("ui_accept"):
		shoot(move_direction)

func shoot(move_direction):
	var b = Bullet.instance()
	b.start(position, rotation)
	get_parent().add_child(b)

func _ready():
	screen_size = get_viewport_rect().size

func _process(delta):
	var move_direction = Vector2(1,0).rotated(rotation)
	get_input(delta, move_direction)
	
	position += motion * move_speed * delta
	position.x = wrapf(position.x, -screen_buffer, screen_size.x + screen_buffer)
	position.y = wrapf(position.y, -screen_buffer, screen_size.y + screen_buffer)
