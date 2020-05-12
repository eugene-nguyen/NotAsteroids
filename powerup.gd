extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

signal powerup_get

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func start(pos):
	position = pos

func _on_Area2D_area_entered(area):
	emit_signal("powerup_get")
	queue_free()
