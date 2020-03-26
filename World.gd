extends Node

var Enemy = preload("res://Enemy.tscn")

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var rng = RandomNumberGenerator.new()
var enemyCount

# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	enemyCount = rng.randi_range(15, 20)
	var i = 0
	while i < enemyCount:
		var enemy_x_position = rng.randi_range(0, 3000)
		var enemy_y_position = rng.randi_range(0, 3000)
		var enemy_turn_speed = rng.randi_range(-100, 100)
		var enemy_move_speed = rng.randi_range(0, 100)
		var enemy_position = Vector2(enemy_x_position, enemy_y_position)
		var enemy_rotation = rng.randi_range(0, 360)
		var e = Enemy.instance()
		e.start(enemy_position, enemy_rotation, enemy_move_speed, enemy_turn_speed)
		add_child(e)
		i = i + 1
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
