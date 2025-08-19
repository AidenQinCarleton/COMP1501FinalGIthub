extends CanvasLayer

signal start_game


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_Start_pressed():
	$Start.hide()
	$Upgrade.hide()
	$Setting.hide()
	$Title.hide()
	$Music.stop()
	get_parent().get_node("HUD").visible = true
	emit_signal("start_game")
