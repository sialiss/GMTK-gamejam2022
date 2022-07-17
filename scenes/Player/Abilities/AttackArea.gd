extends Area2D
class_name AttackArea

export var damage = 1
var waiting = true

func _ready():

	# Need to wait for one frame for the collistions to be processed
	yield(get_tree(), "physics_frame")
	yield(get_tree(), "physics_frame")

	for body in get_overlapping_bodies():
		body.harm(damage)
	queue_free()

# func _physics_process(delta):
	# Need to wait for one frame for the collistions to be processed
	# if waiting:
	# 	print("Hello")
	# 	waiting = false
	# 	return
	#
	# print("Hello-hello!")
	#
	# queue_free()
