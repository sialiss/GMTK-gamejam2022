extends Area2D
class_name AttackArea

export var autostart = true
export var damage = 1

func _ready():
	if autostart:
		start()

func harm(body: Node):
	body.harm(damage)

func start():
	connect("body_entered", self, "harm")

func stop():
	disconnect("body_entered", self, "harm")
	queue_free()
