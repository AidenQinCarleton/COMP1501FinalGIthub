extends CanvasLayer

signal option1
signal option2
signal option3


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	# pause the game
	get_tree().paused = true
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Option1_pressed():
	emit_signal("option1")
	# resume the game
	get_tree().paused = false
	# free the node
	self.queue_free()


func _on_Option2_pressed():
	emit_signal("option2")
	# resume the game
	get_tree().paused = false
	# free the node
	self.queue_free()
	
func _on_Option3_pressed():
	emit_signal("option3")
	get_tree().paused = false
	self.queue_free()

# function to set the text of option 1
func set_option1_text(text):
	$Option1.text = text

# function to set the text of option 2
func set_option2_text(text):
	$Option2.text = text

# hide all the nodes
func hide_all():
	$Label.hide()
	$Option1.hide()
	$Option2.hide()

# show all the nodes
func show_all():
	$Label.show()
	$Option1.show()
	$Option2.show()


func _on_Player_upgrade():
	pass # Replace with function body.




