extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# value of the exp
var value = 1


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func exp():
	pass


func _on_Area2D_body_entered(body):
	# check if the body is a player
	if body.has_method("collect_exp"):
		# call the collect_exp method on the player
		body.collect_exp(value)
		#remove the EXP from the scene
		queue_free()
		
