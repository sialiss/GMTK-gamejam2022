extends CanvasLayer

signal go_to_menu

func show_message(text):
	$Message.text = text
	$Message.show()

func show_message_with_timer(text):
	$Message.text = text
	$Message.show()
	$MessageTimer.start()

func _process(delta):
	$ScoreLabel.text = str(Score.score)

func _on_MessageTimer_timeout():
	$Message.hide()

func _on_MenuButton_pressed():
	emit_signal("go_to_menu")
