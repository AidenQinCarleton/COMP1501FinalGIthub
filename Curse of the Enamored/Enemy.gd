extends KinematicBody2D

# health
var health = 100
# move speed
var speed = 0
# motion vector
var motion = Vector2(0,0)
# damage dealt on collision
var damage = 10
# player variable
onready var p = $"../Player"
var go = false
# Called when the node enters the scene tree for the first time.
func _physics_process(delta):
	if go == true:
		motion = position.direction_to(p.position) * speed
	motion = move_and_slide(motion)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _ready():
	var main = get_parent().get_node("Main")
	main.connect("boss", self, "_on_boss")
	# true random number generator
	randomize()
	# random enemy type
	var rand = randi() % 100
	# if the random number is less than 70, enemy type is zombie
	if rand <70:
		# use zombie sprite
		$AnimatedSprite.animation = "zombie"
		# set the damage to 10
		damage = 10
		# set the health to 10
		health = 10
		# set the speed to 25
		speed = 25
	# if the random number is greater than 70, enemy type is knight
	elif rand > 70:
		# use knight sprite
		$AnimatedSprite.animation = "knight"
		# set the damage to 20
		damage = 20
		# set the health to 20
		health = 20
		# set the speed to 50
		speed = 50

# Generate an exp object, call when the enemy is killed
func generate_exp():
	# load the exp object
	var exp_object = load("EXP.tscn").instance()
	# set the position of the exp object to the position of the enemy
	exp_object.position = position
	# add the exp object to the scene
	get_parent().add_child(exp_object)

func _on_boss():
	queue_free()

func _on_EnemySight_body_entered(body):
	# Detect if the body is a player
	if body.has_method("player"):
		go = true

func _on_EnemyHitBox_body_entered(body):
	# Detect if the body is spawn
	if body.has_method("spawn"):
		damage = body.get_damage()
		health -= damage
		# clean up the spawn
		body.clean_up()
		if health <= 0:
			# call the spawn cleanup function
			body.clean_up()
			# call the generate_exp function
			generate_exp()
			# generate a random number to determine if the enemy drops a gold, chance is 5%
			var rand = randi() % 100
			if rand < 5:
				# load the gold object
				var gold_object = load("Gold.tscn").instance()
				# set the position of the gold object to the position of the enemy
				gold_object.position = position
				# add the gold object to the scene
				get_parent().add_child(gold_object)
			queue_free()

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

