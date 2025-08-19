extends KinematicBody2D

signal health_updated(health)
signal max_health_updated(max_health)
signal death()
signal exp_updated(exp_num)
signal max_exp_updated(max_exp)
signal upgrade()
signal level_up()

export (float) var max_health = 100

var max_exp = 10

onready var health = max_health setget _set_health

onready var enemy_path = get_tree().get_nodes_in_group("EnemyPath")[0]

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var exp_num = 0
var collect_gold = 0
var damage = 10

var player_direction = 1
# Called when the node enters the scene tree for the first time.
func _ready():
	var screen_size = get_viewport_rect().size
	# start timer
	$CoolDown_Spawn.start()
	
var scene_to_instance = preload("res://spawn.tscn")
var spawn = false

func use_spawn(player_direction):
	var bullet = load("spawn.tscn").instance()
	bullet.set_damage(damage)
	get_parent().add_child(bullet)
	
var timer = 0 #keeps track of length of time since last projectile
var cooldown = 100 #change this to change cooldown time
var movement_speed = 2 #this changes how fast the player moves

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = Vector2.ZERO
	$AnimatedSprite.play("default")
	if Input.is_action_pressed("move_right"):
		global_position.x = global_position.x + movement_speed
		player_direction = 1
		velocity.x += 1
		# move enemy path with player
		enemy_path.global_position.x = enemy_path.global_position.x + movement_speed
	if Input.is_action_pressed("move_left"):
		global_position.x = global_position.x - movement_speed
		player_direction = 2
		velocity.x -= 1
		# move enemy path with player
		enemy_path.global_position.x = enemy_path.global_position.x - movement_speed
	if Input.is_action_pressed("move_up"):
		global_position.y = global_position.y - movement_speed
		player_direction = 3
		velocity.y -= 1
		# move enemy path with player
		enemy_path.global_position.y = enemy_path.global_position.y - movement_speed
	if Input.is_action_pressed("move_down"):
		global_position.y = global_position.y + movement_speed
		player_direction = 4
		velocity.y += 1
		# move enemy path with player
		enemy_path.global_position.y = enemy_path.global_position.y + movement_speed
	
# Place holder, use for enemy to detect if player enter collision shape
func player():
	pass

# Method to pick up EXP
func collect_exp(amount):
	exp_num += amount
	# send signal to update exp
	emit_signal("exp_updated", exp_num)
	# check if player level up
	if exp_num >= max_exp:
		# reset exp
		exp_num = 0
		# level up
		level_up()

# Method to pick up gold
func collect_gold(amount):
	collect_gold += amount

# level up
func level_up():
	emit_signal("level_up")
	# increase max health
	max_health += 10
	# increase damage
	damage += 5
	# increase max exp
	max_exp += 10
	# send signal to update max exp
	emit_signal("max_exp_updated", max_exp)
	# update exp
	emit_signal("exp_updated", exp_num)
	# intantiate upgrade menu
	var upgrade_menu = load("InGameUpgrade.tscn").instance()
	# connect signal to upgrade menu
	upgrade_menu.connect("option1", self, "upgrade_opt1")
	upgrade_menu.connect("option2", self, "upgrade_opt2")
	upgrade_menu.connect("option3", self, "upgrade_opt3")
	add_child(upgrade_menu)

# Placeholder for func that passes when player dies
func kill():
	self.queue_free()

# when option1 is selected
func upgrade_opt1():
	# increase damage
	damage += 10
	# recover health
	_set_health(max_health)

# when option2 is selected
func upgrade_opt2():
	# increase max health
	max_health += 10
	# call to update max health
	emit_signal("max_health_updated", max_health)
	# recover health
	_set_health(max_health)

# when option3 is selected
func upgrade_opt3():
	# decrease cooldown
	# judge if cooldown is less than 0.1
	if $CoolDown_Spawn.wait_time <= 0.1:
		$CoolDown_Spawn.wait_time = 0.1
	else:
		$CoolDown_Spawn.wait_time -= 0.1

func _set_health(value):
	var health_before = health
	health = clamp(value, 0, max_health)
	if health != health_before:
		emit_signal("health_updated", health)
		if health == 0:
			kill()
			emit_signal("death")


func _on_HitBoxArea_body_entered(body):
	#detect what the body is
	#if body.has_method("generate_exp"):
	#_set_health(health - body.damage)
	if body.has_method("enemy"):
		_set_health(health - body.damage)

func _on_Timer_timeout():
	use_spawn(player_direction)

# get set functions

# get current damage
func get_damage():
	return damage

# set current damage
func set_damage(value):
	damage = value

# get current exp
func get_exp():
	return exp_num

# get current gold
func get_gold():
	return collect_gold

# get max exp
func get_max_exp():
	return max_exp

