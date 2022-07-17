extends Node2D

onready var player = $YSort/Player

var menu_scene = load("res://scenes/Menu/Menu.tscn")

export(Dictionary) var mobs = {}

var mob_bag = RNGTools.WeightedBag.new()

func _ready():
	mob_bag.set_weights(mobs)
	new_game()

func new_game():
	player.start($YSort/StartPosition2D.position)
	Score.score = 0
	$StartTimer.start()
	$Music.play()
	$HUD.get_ready()

func game_over():
	$Music.stop()
	$HUD/MenuButton.hide()
	$DeathSound.stream.loop = false
	$DeathSound.play()
	yield($DeathSound, "finished")
	if Score.score > Score.best_score:
		Score.best_score = Score.score

	get_tree().change_scene_to(menu_scene)

func _on_MobTimer_timeout():
	# Create a new instance of the Mob scene.
	# var mob = mob_scenes[randi() % mob_scenes.size()].instance()
	var mob = RNGTools.pick_weighted(mob_bag).instance()

	# Choose a random location on Path2D.
	var mob_spawn_location = get_node("YSort/MobPath2D/PathFollow2D")
	mob_spawn_location.offset = randi()

	# Spawn the mob by adding it to the Main scene.
	$YSort.add_child(mob)

	mob.set_location(mob_spawn_location)

func _on_StartTimer_timeout():
	$MobTimer.start()

func _on_HUD_go_to_menu():
	$YSort/Player.die()
