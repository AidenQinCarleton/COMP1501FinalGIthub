extends Control


func _on_Continue_pressed():
	get_parent().get_node("Instructions").visible = false
	get_parent().get_node("StartMenu").visible = true
	
