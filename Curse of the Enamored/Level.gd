extends Label
var level = 0
func _ready():
	var p = get_tree().get_nodes_in_group("Player")[0]
	p.connect("level_up", self, "_on_level_up")
	_on_level_up()

func _on_level_up():
	text = " "
	text = "Level: " + str(level)
	level += 1
	

	
