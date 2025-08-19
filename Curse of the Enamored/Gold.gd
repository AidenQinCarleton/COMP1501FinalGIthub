extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Value of the gold
var value = 1


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func gold():
	pass


func _on_Area2D_body_entered(body):
	# check if the body is a player
	if body.has_method("collect_gold"):
		# call the collect gold method on the player
		body.collect_gold(value)
		#remove the EXP from the scene
		queue_free()
