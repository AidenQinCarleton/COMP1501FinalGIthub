extends KinematicBody2D

# var direction = Vector2(1.0,0.0)
var speed = 300.0
var target = null
var velocity = Vector2(0.0,0.0)
var damage = 0

func _ready():
	# set initial position to player
	global_position = get_tree().get_nodes_in_group("Player")[0].global_position
	# check the closest enemy, if no enemies, set a random direction
	var enemies = get_tree().get_nodes_in_group("Enemies")
	if enemies.size() == 0:
		var direction = Vector2(rand_range(-1.0,1.0), rand_range(-1.0,1.0))
		var velocity = direction * speed
		move_and_slide(velocity)
	else:
		# set the target to the closest enemy
		var closest_distance = 1000000.0
		for enemy in enemies:
			var distance = enemy.global_position.distance_to(global_position)
			if distance < closest_distance:
				closest_distance = distance
				target = enemy
		# set the direction to the target
		var direction = (target.global_position - global_position).normalized()
		# set the velocity
		velocity = direction * speed
		# move the spawn
		move_and_slide(velocity)

func _process(delta):
	# # check if the target is still alive by checking if has been previously freed
	# if target != null and target.is_queued_for_deletion():
	# 	target = null
	# # if target is still alive, move towards it
	# if target != null:
	# 	var direction = (target.global_position - global_position).normalized()
	# 	var velocity = direction * speed
	# 	move_and_slide(velocity)
	# else:
	# 	# if target got killed, remove the spawn
	# 	clean_up()
	# move the spawn
	move_and_slide(velocity)

# Place holder, use for enemies to detect if they are hit by the spawn 
func spawn():
  pass

# clean up the spawn, called when the spawn needs to be removed
func clean_up():
  queue_free()

# function to set the damage of the spawn
func set_damage(damage):
  self.damage = damage

# function to get the damage of the spawn
func get_damage():
  return damage
