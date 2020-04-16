extends Node

# Player variables.
var lives = 3
var score = 0

# Enemy variables.
var Enemy = preload("res://Enemy.tscn")
var rng = RandomNumberGenerator.new()
var remaining_enemies
var max_enemies_in_round
var current_min_enemies = 8
var current_max_enemies = 10

# Signals.
signal game_over

func spawn_enemies(min_enemies, max_enemies):
	max_enemies_in_round = rng.randi_range(min_enemies, max_enemies)
	remaining_enemies = max_enemies_in_round
	var i = 0
	for i in range(max_enemies_in_round):
		var enemy_x_position = rng.randi_range(0, 3000)
		var enemy_y_position = rng.randi_range(0, 3000)
		var enemy_turn_speed = rng.randi_range(-100, 100)
		var enemy_move_speed = rng.randi_range(0, 100)
		var enemy_position = Vector2(enemy_x_position, enemy_y_position)
		var enemy_rotation = rng.randi_range(0, 360)
		var e = Enemy.instance()
		e.start(enemy_position, enemy_rotation, enemy_move_speed, enemy_turn_speed)
		e.connect("enemy_got_hit", self, "_on_Enemy_enemy_got_hit")
		connect("game_over", e, "_on_World_game_over")
		add_child(e)

func round_start():
	$Player._ready()
	$StartTimer.set_wait_time(3)
	$StartTimer.start()
	$UI.show_message("Get Ready")

# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_StartTimer_timeout():
	$Player.start($StartPosition.position)
	current_min_enemies += 3
	current_max_enemies += 3
	spawn_enemies(current_min_enemies, current_max_enemies)
	$StartTimer.stop()

func _on_UI_start_game():
	lives = 3
	score = 0
	current_min_enemies = 8
	current_max_enemies = 10
	$UI.life_count(lives)
	$UI.score_count(score)
	round_start()

func _on_Player_player_got_hit():
	lives -= 1
	score -= 100
	$UI.life_count(lives)
	$UI.score_count(score)
	if (lives == 0):
		emit_signal("game_over")
		$UI.show_game_over()

func _on_Enemy_enemy_got_hit():
	remaining_enemies -= 1
	score += 100
	$UI.score_count(score)
	if (remaining_enemies == 0):
		lives += min(lives + 1, 10)
		round_start()
