extends CanvasLayer
func _ready():
	# pause the game
	get_tree().paused = true
func _on_Button_pressed():
	# resume the game
	get_tree().paused = false
	# free the node
	self.queue_free()
