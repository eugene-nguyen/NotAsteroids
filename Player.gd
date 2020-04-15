extends KinematicBody2D

signal hit

export (int) var turn_speed = 180
export (int) var move_speed = 150
export (float) var acceleration = 0.05
export (float) var deceleration = 0.025
var motion = Vector2(0, 0)

var screen_size
var screen_buffer = 8

var in_play = true # If this becomes false (when game over occurs), then the player doesn't respawn, obviously.)
var respawn_time = 3
var respawn_timer
var invuln_time = 3
var invuln_timer

signal player_got_hit
var Bullet = preload("res://Bullet.tscn")

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
	hide()

func _process(delta):
	var move_direction = Vector2(1,0).rotated(rotation)
	get_input(delta, move_direction)
	
	position += motion * move_speed * delta
	position.x = wrapf(position.x, -screen_buffer, screen_size.x + screen_buffer)
	position.y = wrapf(position.y, -screen_buffer, screen_size.y + screen_buffer)




func _on_Player_body_entered(body):
	hide()
	emit_signal("hit")
	$DamageDetector/CollisionShape2D.set_deferred("disabled", true)
	
func start(pos):
	position = pos
	show()
	$DamageDetector/CollisionShape2D.disabled=false


func _on_Player_area_entered(area):
	pass

func _on_DamageDetector_area_entered(area):
	emit_signal("player_got_hit")
	$DamageDetector/CollisionShape2D.set_deferred("disabled", true)
	hide()
	if (in_play):
		respawn_timer = get_node("RespawnTimer")
		respawn_timer.set_wait_time(respawn_time)
		respawn_timer.start()
	print("Player has been hit!")


func _on_RespawnTimer_timeout():
	position.x = 500
	position.y = 275
	rotation_degrees = 0
	motion = Vector2(0, 0)
	respawn_timer.stop()
	show()
	print("Player has respawned! (Invulnerable!)")
	invuln_timer = get_node("InvulnTimer")
	invuln_timer.set_wait_time(respawn_time)
	invuln_timer.start()


func _on_InvulnTimer_timeout():
	$DamageDetector/CollisionShape2D.disabled = false
	print("Player is no longer invulnerable!")
