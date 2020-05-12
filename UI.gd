extends CanvasLayer

signal start_game
signal start_enhanced

func life_count(lives):
	$LifeLabel.text = str(lives)
	$LifeLabel.show()

func score_count(score):
	$ScoreValue.text = str(score)
	$ScoreValue.show()

func show_message(text):
	$MessageLabel.text = text
	$MessageLabel.show()
	$MessageTimer.start()

#function that shows the game over screen
#when you are dead
func show_game_over():
	emit_signal("game_over")
	show_message("Game Over")
	yield($MessageTimer, "timeout")
	
	$MessageLabel.text="Eugenes Creme"
	$MessageLabel.show()
	
	#yield(get_tree().create_timer(1),"timeout")
	
	$StartButton.show()
	
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_StartButton_pressed():
	$StartButton.hide()
	$StartButton2.hide()
	emit_signal("start_game")
	print("Button was printed")


func pressed():
	pass


func _on_MessageTimer_timeout():
	$MessageLabel.hide()


func _on_StartButton2_pressed():
	$StartButton.hide()
	$StartButton2.hide()
	emit_signal("start_enhanced")
	print("Enhanced start Button was printed")
