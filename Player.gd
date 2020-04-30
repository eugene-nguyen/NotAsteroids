extends KinematicBody2D

# Movement variables.
const turn_speed = 200
const move_speed = 475
const acceleration = 0.05
const deceleration = 0.01
var motion = Vector2(0, 0)

var screen_size
var screen_buffer = 8

var can_input = false
var game_active = false # If this becomes false (when game over occurs), then the player doesn't respawn

const starting_position = Vector2(640, 360)

# Timer stuff.
var respawn_timer
var invuln_timer
const time_interval = 3

# Connections to other nodes.
signal player_damaged
var Bullet = preload("res://Bullet.tscn")

# Controls and player actions.
func get_input(delta, move_direction):
	if can_input:
		if Input.is_action_pressed("ui_left"):
			rotation_degrees -= turn_speed * delta
		elif Input.is_action_pressed("ui_right"):
			rotation_degrees += turn_speed * delta
		
		if Input.is_action_pressed("ui_up"):
			motion = motion.linear_interpolate(move_direction, acceleration)
			$Sprite.animation = "Go"
		else:
			motion = motion.linear_interpolate(Vector2(0, 0), deceleration)
			$Sprite.animation = "Stopped"
		if Input.is_action_just_pressed("ui_accept"):
			shoot(move_direction)
	else:
		pass

func shoot(move_direction):
	var b = Bullet.instance()
	$"AudioShooting".play()
	b.start(position, rotation)
	get_parent().add_child(b)
	motion = motion.linear_interpolate(-move_direction, acceleration*1.5)

# General methods.

func despawn_self():
	$DamageDetector/CollisionShape2D.set_deferred("disabled", true)
	can_input = false
	hide()

func spawn_self():
	game_active = true
	can_input = true
	position = starting_position
	motion = Vector2(0, 0)
	set_timer(invuln_timer)
	show()
	$Shield.show()

func set_timer(timer):
	timer.set_wait_time(time_interval)
	timer.start()

func set_game_status(status):
	game_active = status

# This method calls itself when a Player node is created.
func _ready():
	despawn_self()
	screen_size = get_viewport_rect().size
	respawn_timer = get_node("RespawnTimer")
	invuln_timer = get_node("InvulnTimer")

# This method calls itself every frame it exists. Used for the special movement.
func _process(delta):
	var move_direction = Vector2(1,0).rotated(rotation)
	get_input(delta, move_direction)
	
	position += motion * move_speed * delta
	position.x = wrapf(position.x, -screen_buffer, screen_size.x + screen_buffer)
	position.y = wrapf(position.y, -screen_buffer, screen_size.y + screen_buffer)

# Signal connections.
func _on_DamageDetector_area_entered(area):
	
	emit_signal("player_damaged")
	$"AudioGameOverCrash".play()

	
	despawn_self()
	if (game_active):
		set_timer(respawn_timer)

func _on_InvulnTimer_timeout():
	$DamageDetector/CollisionShape2D.disabled = false
	$Shield.hide()
	invuln_timer.stop()

func _on_RespawnTimer_timeout():
	spawn_self()
	respawn_timer.stop()
