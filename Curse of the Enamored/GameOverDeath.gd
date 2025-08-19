extends CanvasLayer
signal new_game
func _on_Button_pressed():
	emit_signal("new_game")
	self.queue_free()
