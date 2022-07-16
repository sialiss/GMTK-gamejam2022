extends Node2D

onready var player = $YSort/Player

export(Array, PackedScene) var mob_scenes = []
var score

func _ready():
	# $HUD/StartButton.hide()
	# $HUD/CreditsButton.hide()
	# $HUD/Gameochka.hide()
	# new_game()
	$MenuMusic.play()
	$Credits.hide()

# Called when the node enters the scene tree for the first time.

func new_game():
	score = 0
	player.start($YSort/StartPosition2D.position)
	$StartTimer.start()
	$MenuMusic.stop()
	$Music.play()
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")

func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_over()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

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
	$ScoreTimer.start()

func _on_Player_hit():
	score += 1
	$HUD.update_score(score)

func _on_HUD_close_game():
	get_tree().quit()

func _on_HUD_go_to_credits():
	$Credits.show()

func _on_Credits_go_to_menu():
	$Credits.hide()
