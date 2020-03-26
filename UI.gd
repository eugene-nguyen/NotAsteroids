extends CanvasLayer

signal start_game


func show_message(text):
	$MessageLabel.text = text
	$MessageLabel.show()
	$MessageTimer.start()



#function that shows the game over screen
#when you are dead
func show_game_over():
	show_message("Game Over")
	yield($MessageTimer, "timeout")
	
	$MessageLabel.text="Eugenes Creme"
	$MessageLabel.show()
	
	yield(get_tree().create_timer(1),"timeout")
	
	$StartButton.show()
	
	


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_StartButton_pressed():
	$StartButton.hide()
	emit_signal("start_game")
	print("Button was printed")



func pressed():
	pass


func _on_MessageTimer_timeout():
	$MessageLabel.hide()
