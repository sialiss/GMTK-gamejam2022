extends Area2D
class_name HealingArea

export var autostart = true
export var health = 1

func _ready():
	if autostart:
		start()

func harm(body: Node):
	body.heal(health)

func start():
	connect("body_entered", self, "harm")

func stop():
	disconnect("body_entered", self, "harm")
	queue_free()
