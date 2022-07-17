extends CanvasLayer
signal go_to_menu

func _on_Menu_pressed():
	emit_signal("go_to_menu")

func _on_LinkButton_pressed():
	OS.shell_open("https://github.com/sialiss/GMTK-gamejam2022")

func _on_Blinkfox_pressed():
	OS.shell_open("https://github.com/blink-fox")

func _on_Camellia_pressed():
	OS.shell_open("https://github.com/sialiss")