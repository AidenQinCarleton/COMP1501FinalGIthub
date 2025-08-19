extends Node
export (PackedScene) var enemy_scene
signal boss
var game_level = 1
var spawn_enemy = true

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()

var spawn = false
var num = 0

func instance_player():
	spawn = true
	var player = load("Player.tscn").instance()
	get_parent().add_child(player)
	player.connect("death", self, "_on_Player_death")

# initialize the health bar
func instance_health_bar():
	var health_bar = load("Health_Bar.tscn").instance()
	get_parent().add_child(health_bar)

# initialize the EXP bar
func instance_exp_bar():
	var exp_bar = load("EXPBar.tscn").instance()
	get_parent().add_child(exp_bar)

#initialize the Level Counter
func instance_level():
	var level = load("Level.tscn").instance()
	get_parent().add_child(level)

#initialize boss intro
func instance_boss_intro():
	var boss_intro = load("BossIntro.tscn").instance()
	get_parent().add_child(boss_intro)

#initialize boss
func instance_boss():
	var boss = load("Boss.tscn").instance()
	get_parent().add_child(boss)
	boss.connect("boss_defeated", self, "_on_boss_defeated")

#initialize boss health bar
func instance_boss_health_bar():
	var boss_hp = load("Boss_Health_Bar.tscn").instance()
	get_parent().add_child(boss_hp)

#initialize Game Over Death Screen
func instance_Game_Over_Death():
	var game_over_death = load("GameOverDeath.tscn").instance()
	get_parent().add_child(game_over_death)
	game_over_death.connect("new_game", self, "_on_new_game")

#initialize Game Over Win Screen
func instance_Game_Over_Win():
	var game_over_win = load("GameOverWin.tscn").instance()
	get_parent().add_child(game_over_win)
	game_over_win.connect("new_game", self, "_on_new_game")

# show up warning message
func show_warning():
	var warning = load("StrongerWarning.tscn").instance()
	get_parent().add_child(warning)

func _on_boss_defeated():
	spawn_enemy = true
	$GenerateTimer.stop()
	$GameCountDown.stop()
	game_level = 1
	get_tree().call_group("Player", "queue_free")
	get_tree().call_group("Enemies", "queue_free")
	get_tree().call_group("Drops", "queue_free")
	# clean up the gold
	get_tree().call_group("Golds", "queue_free")
	# clean up spawn
	get_tree().call_group("spawn", "queue_free")
	$"Background Music".stop()
	instance_Game_Over_Win()
	$HUD.visible = false
	# free the health bar
	get_tree().call_group("HealthBar", "queue_free")
	# free the EXP bar
	get_tree().call_group("EXPBar", "queue_free")
	# free the Level Counter
	get_tree().call_group("Level", "queue_free")
	$ParallaxBackground.hide()
	
func _on_GenerateTimer_timeout():
	if spawn_enemy:
		# Create an instance of the enemy scene
		var enemy = load("Enemy.tscn").instance()

		# chose a random position on the path
		var enemy_spawn_position = get_node("EnemiesPath/EnemiesSpawnLocation")
		enemy_spawn_position.offset = randi()

		# set enemy position
		enemy.position = enemy_spawn_position.get_global_position()

		# add enemy to the scene
		get_parent().add_child(enemy)
	
		# scale the enemy
		enemy.scale(game_level)
	


func _on_StartMenu_start_game():
	# start generating enemies
	get_node("GenerateTimer").start()
	# start GameCountDown
	get_node("GameCountDown").start()
	# generate the player
	instance_player()
	# generate the health bar
	instance_health_bar()
	$"Background Music".play()
	# generate the EXP bar
	instance_exp_bar()
	#instance level counter
	instance_level()
	$ParallaxBackground.show()


func _on_Player_death():
	$GenerateTimer.stop()
	$GameCountDown.stop()
	game_level = 1
	get_tree().call_group("Enemies", "queue_free")
	get_tree().call_group("Drops", "queue_free")
	# clean up the gold
	get_tree().call_group("Golds", "queue_free")
	# clean up spawn
	get_tree().call_group("spawn", "queue_free")
	$"Background Music".stop()
	instance_Game_Over_Death()
	$HUD.visible = false
	# free the health bar
	get_tree().call_group("HealthBar", "queue_free")
	# free the EXP bar
	get_tree().call_group("EXPBar", "queue_free")
	# free the Level Counter
	get_tree().call_group("Level", "queue_free")
	$ParallaxBackground.hide()

func _on_new_game():
	$ParallaxBackground.hide()
	$"StartMenu/Start".show()
	$"StartMenu/Upgrade".show()
	$"StartMenu/Setting".show()
	$"StartMenu/Title".show()
	$"StartMenu/Music".play()


func _on_GameCountDown_timeout():
	game_level += 1
	# show up warning message
	if game_level == 3:
		#get all other enemies to despawn
		emit_signal("boss")
		instance_boss_intro()
		#stop spawning new enemies
		spawn_enemy = false
		#spawn boss and boss health bar
		instance_boss()
		instance_boss_health_bar()
	else:
		show_warning()
