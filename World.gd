extends Node



# Player variables.
var lives = 3
var score = 0

# Enemy variables.
var Enemy = preload("res://Enemy.tscn")
var rng = RandomNumberGenerator.new()
var remaining_enemies
var max_enemies_in_round

# Signals.
signal game_over

func spawn_enemies(min_enemies, max_enemies):
	max_enemies_in_round = rng.randi_range(min_enemies, max_enemies)
	remaining_enemies = max_enemies_in_round
	var i = 0
	while i < max_enemies_in_round:
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

func round_start():
	$Player.start($StartPosition.position)

# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	spawn_enemies(15, 20)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (lives == 0):
		emit_signal("game_over")
		$UI.show_game_over()
	if (remaining_enemies == 0):
		round_start()

func _on_StartTimer_timeout():
	round_start()

func _on_UI_start_game():
	$Player._ready()
	$StartTimer.start()
	$UI.show_message("Get Ready")

func _on_Player_player_got_hit():
	lives -= 1
	$UI.life_count(lives)

func _on_Enemy_enemy_got_hit():
	print("enemy got hit")
