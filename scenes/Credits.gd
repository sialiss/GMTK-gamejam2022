extends CanvasLayer
signal go_to_menu

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_Menu_pressed():
	emit_signal("go_to_menu")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass