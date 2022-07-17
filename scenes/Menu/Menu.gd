extends CanvasLayer

var game_scene = load("res://scenes/Game.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	$MenuMusic.play()
	$Credits.hide()
	show_best_score()
	update_score()
	if OS.get_name() == "HTML5":
		$CloseButton.hide()

func show_message(text):
	$Message.text = text
	$Message.show()

func show_best_score():
	show_message("Best score: %s" % Score.best_score)
	$Message.show()

func update_score():
	$ScoreLabel.text = str(Score.score)

func _on_StartButton_pressed():
	get_tree().change_scene_to(game_scene)

func _on_MessageTimer_timeout():
	$Message.hide()

func _on_ExitButton_pressed():
	get_tree().quit()

func _on_CreditsButton_pressed():
	$Credits.show()

func _on_Credits_go_to_menu():
	$Credits.hide()

func _on_CloseButton_pressed():
	get_tree().quit()
