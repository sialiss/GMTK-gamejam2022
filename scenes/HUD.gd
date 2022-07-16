extends CanvasLayer

signal start_game
signal close_game
signal go_to_credits
signal go_to_menu

# Called when the node enters the scene tree for the first time.
func _ready():
	$MenuButton.hide()

func show_message(text):
	$Message.text = text
	$Message.show()
	$MessageTimer.start()

func show_game_over():
	show_message("Game Over")
	# Wait until the MessageTimer has counted down.
	yield($MessageTimer, "timeout")

	$Message.show()
	# Make a one-shot timer and wait for it to finish.
	yield(get_tree().create_timer(1), "timeout")
	$StartButton.show()

func update_score(score):
	$ScoreLabel.text = str(score)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_StartButton_pressed():
	$StartButton.hide()
	$CreditsButton.hide()
	$Gameochka.hide()
	$CloseButton.hide()
	$MenuButton.show()
	emit_signal("start_game")

func _on_MessageTimer_timeout():
	$Message.hide()

func _on_ExitButton_pressed():
	emit_signal("close_game")

func _on_Credits_pressed():
	emit_signal("go_to_credits")

func _on_MenuButton_pressed():
	var currentScene = get_tree().get_current_scene().get_filename()
	get_tree().change_scene(currentScene)
