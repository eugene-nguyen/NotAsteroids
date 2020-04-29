extends Node

# Player variables.
var lives = 3
var score = 0

# Enemy variables.
var Enemy = preload("res://Enemy.tscn")
var rng = RandomNumberGenerator.new()
var enemies_in_round
var current_min_enemies = 6
var current_max_enemies = 12

# Signals.
signal game_over

func update_scoreboard():
	$UI.life_count(lives)
	$UI.score_count(score)

func spawn_enemies(number_to_spawn):
	var i = 0
	for i in range(number_to_spawn):
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
	$Player.spawn_self()
	enemies_in_round = rng.randi_range(current_min_enemies, current_max_enemies)
	spawn_enemies(enemies_in_round)
	current_min_enemies = min(current_min_enemies + 1, 20)
	current_max_enemies = min(current_max_enemies + 2, 40)
	$StartTimer.stop()

func _on_UI_start_game():
	lives = 3
	score = 0
	current_min_enemies = 6
	current_max_enemies = 12
	update_scoreboard()
	round_start()

func _on_Enemy_enemy_got_hit():
	score += 100
	if (get_tree().get_nodes_in_group("ENEMIES").size()):
		lives = min(lives + 1, 10)
		round_start()
	update_scoreboard()

func _on_Player_player_damaged():
	lives -= 1
	score -= 100
	update_scoreboard()
	if (lives == 0):
		$Player.set_game_status(false)
		emit_signal("game_over")
		$UI.show_game_over()
