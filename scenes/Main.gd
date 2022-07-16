extends Node2D


export(Array, PackedScene) var mob_scenes = []
var score

func _ready():
	$MenuMusic.play()
	$Credits.hide()
	randomize()

	# $HUD._on_StartButton_pressed()

# Called when the node enters the scene tree for the first time.

func new_game():
	score = 0
	$YSort/Player.start($YSort/StartPosition2D.position)
	$StartTimer.start()
	$MenuMusic.stop()
	$Music.play()
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")

func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()
	$YSort/Player.hide()
	$HUD.show_game_over()

	$Music.stop()
	$MenuMusic.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_MobTimer_timeout():
	# Create a new instance of the Mob scene.
	var mob = mob_scenes[randi() % mob_scenes.size()].instance()

	# Choose a random location on Path2D.
	var mob_spawn_location = get_node("YSort/MobPath2D/PathFollow2D")
	mob_spawn_location.offset = randi()

	# Set the mob's direction perpendicular to the path direction.
	var direction = mob_spawn_location.rotation + PI / 2

	# Set the mob's position to a random location.
	mob.position = mob_spawn_location.position

	# Add some randomness to the direction.
	direction += rand_range(-PI / 4, PI / 4)
	mob.rotation = direction

	# Choose the velocity for the mob.
	var velocity = Vector2(rand_range(150.0, 250.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)

	# Spawn the mob by adding it to the Main scene.
	$YSort.add_child(mob)

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
