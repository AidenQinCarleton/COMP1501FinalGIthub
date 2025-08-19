extends CanvasLayer


onready var boss_health_bar = $HealthBar

func _ready():
	var boss = get_tree().get_nodes_in_group("Enemies")[0]
	boss.connect("boss_health_updated", self, "_on_health_updated")
	boss.connect("boss_max_health_updated", self, "_on_max_health_updated")

func _on_health_updated(health):
	boss_health_bar.value = health

func _on_max_health_updated(max_health):
	boss_health_bar.max_value = max_health
