extends CanvasLayer


onready var exp_bar = $ProgressBar


# Called when the node enters the scene tree for the first time.
func _ready():
	var p = get_tree().get_nodes_in_group("Player")[0]
	p.connect("exp_updated", self, "_on_exp_updated")
	p.connect("max_exp_updated", self, "_on_max_exp_updated")
	_on_max_exp_updated(p.get_max_exp())


# exp_updated signal handler
func _on_exp_updated(new_exp):
	exp_bar.value = new_exp

# update max exp
func _on_max_exp_updated(max_exp):
	exp_bar.max_value = max_exp
