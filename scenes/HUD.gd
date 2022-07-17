extends CanvasLayer

signal go_to_menu

func show_message(text):
	$Message.text = text
	$Message.show()

func show_message_with_timer(text):
	$Message.text = text
	$Message.show()
	$MessageTimer.start()

func update_score(score):
	$ScoreLabel.text = str(score)

func _on_MessageTimer_timeout():
	$Message.hide()

func _on_MenuButton_pressed():
	# var currentScene = get_tree().get_current_scene().get_filename()
	# get_tree().change_scene(currentScene)

	emit_signal("go_to_menu")
