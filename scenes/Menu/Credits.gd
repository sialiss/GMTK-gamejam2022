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


func _on_LinkButton_pressed():
	OS.shell_open("https://github.com/sialiss/GMTK-gamejam2022")


func _on_Blinkfox_pressed():
	OS.shell_open("https://github.com/blink-fox")


func _on_Camellia_pressed():
	OS.shell_open("https://github.com/sialiss")
