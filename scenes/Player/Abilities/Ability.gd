extends Node2D
class_name Ability

export(NodePath) var timer

func _ready():
	if timer:
		var timer_node: Node = get_node(timer)
		if timer_node.has_signal("timeout"):
			timer_node.connect("timeout", self, "detach")


func attach(host: Node2D):
	host.add_child(self)

func detach():
	queue_free()
