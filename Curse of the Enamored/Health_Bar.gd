extends CanvasLayer


onready var health_bar = $HealthBar

func _ready():
	var p = get_tree().get_nodes_in_group("Player")[0]
	p.connect("health_updated", self, "_on_health_updated")
	p.connect("max_health_updated", self, "_on_max_health_updated")

func _on_health_updated(health):
	health_bar.value = health

func _on_max_health_updated(max_health):
	health_bar.max_value = max_health
