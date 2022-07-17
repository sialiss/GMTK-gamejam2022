extends Node2D


onready var player = $YSort/Player
var menu_scene = load("res://scenes/Menu/Menu.tscn")
export(Array, PackedScene) var mob_scenes = []

func _ready():
	new_game()

func new_game():
	player.start($YSort/StartPosition2D.position)
	Score.score = 0
	$StartTimer.start()
	$Music.play()
	$HUD.update_score(Score.score)
	$HUD.show_message_with_timer("Get Ready")

func game_over():
	$Music.stop()
	$YSort/Player.die()
	$DeathSound.stream.loop = false
	$DeathSound.play()
	yield($DeathSound, "finished")
	if Score.score > Score.best_score:
		Score.best_score = Score.score
	
	# get_tree().call_group("enemies", "queue_free")
	get_tree().change_scene_to(menu_scene)

func _on_MobTimer_timeout():
	# Create a new instance of the Mob scene.
	var mob = mob_scenes[randi() % mob_scenes.size()].instance()

	# Choose a random location on Path2D.
	var mob_spawn_location = get_node("YSort/MobPath2D/PathFollow2D")
	mob_spawn_location.offset = randi()

	# Spawn the mob by adding it to the Main scene.
	$YSort.add_child(mob)

	mob.set_location(mob_spawn_location)

func _on_StartTimer_timeout():
	$MobTimer.start()

func _on_Player_hit():
	Score.score += 1
	# $HUD.update_score(Score.score)

