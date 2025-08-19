extends KinematicBody2D
signal boss_defeated
# health
export (float) var max_health = 500
onready var health = max_health setget _set_health
# move speed
var speed = 50
# motion vector
var motion = Vector2(0,0)
# damage dealt on collision
var damage = 30
# player variable
onready var p = $"../Player"
var go = false
# Called when the node enters the scene tree for the first time.
func _physics_process(delta):
	$AnimatedSprite.play("run")
	if go == true:
		motion = position.direction_to(p.position) * speed
	motion = move_and_slide(motion)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

# Place holder
func enemy():
	pass

# scale the enemy
func scale(scale):
	# scale the health
	health = health * scale
	# scale the damage
	damage = damage * scale
	# scale the speed
	speed = speed * scale


func _on_BossSight_body_entered(body):
		# Detect if the body is a player
	if body.has_method("player"):
		go = true

func _set_health(value):
	var health_before = health
	health = clamp(value, 0, max_health)
	if health != health_before:
		emit_signal("boss_health_updated", health)

func _on_BossHitBox_body_entered(body):
	# Detect if the body is spawn
	if body.has_method("spawn"):
		damage = body.get_damage()
		_set_health(health - damage)
		# clean up the spawn
		body.clean_up()
		if health == 0:
			# call the spawn cleanup function
			body.clean_up()
			emit_signal("boss_defeated")
			queue_free()
