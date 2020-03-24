extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var turn_speed
var move_speed
var motion = Vector2()

var screen_size
var screen_buffer = 8

func start(pos, dir, mov, tur):
	rotation = dir
	position = pos
	move_speed = mov
	turn_speed = tur
	motion = Vector2(move_speed, 0).rotated(rotation)
	
func _physics_process(delta):
	var collision = move_and_collide(motion * delta)
	if collision:
		motion = motion.bounce(collision.normal)
		if collision.collider.has_method("hit"):
			collision.collider.hit()


func _ready():
	screen_size = get_viewport_rect().size

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	rotation_degrees += turn_speed * delta
	position.x = wrapf(position.x, -screen_buffer, screen_size.x + screen_buffer)
	position.y = wrapf(position.y, -screen_buffer, screen_size.y + screen_buffer)
