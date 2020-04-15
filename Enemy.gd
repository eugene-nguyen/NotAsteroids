extends KinematicBody2D

var turn_speed
var move_speed
var velocity = Vector2()

var screen_size
var screen_buffer = 8

signal enemy_got_hit

func start(pos, dir, mov, tur):
	rotation = dir
	position = pos
	move_speed = mov
	turn_speed = tur
	velocity = Vector2(move_speed, 0).rotated(rotation)
	
func _physics_process(delta):
	var collision = move_and_collide(velocity * delta)
	if collision:
		velocity = velocity.bounce(collision.normal)

func _ready():
	screen_size = get_viewport_rect().size

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	rotation_degrees += turn_speed * delta
	position.x = wrapf(position.x, -screen_buffer, screen_size.x + screen_buffer)
	position.y = wrapf(position.y, -screen_buffer, screen_size.y + screen_buffer)

func _on_EnemyDetector_body_shape_entered(body_id, body, body_shape, area_shape):
	print("enemies touched! ew!") 
	#velocity = velocity.bounce()

func _on_BulletDetector_area_entered(area):
	emit_signal("enemy_got_hit")
	queue_free()

