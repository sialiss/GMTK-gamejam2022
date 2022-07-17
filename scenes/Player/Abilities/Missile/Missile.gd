extends Node2D

export(float) var speed = 300.0
export var damage = 1
export var duration = 3

var target: Node2D = null


func _ready():
	$Area.connect("body_entered", self, "on_collision")
	Ticker.once(self, duration).then(self, "destroy")


func set_target(enemy: Node2D):
	target = enemy


func _physics_process(delta):
	if target and is_instance_valid(target):
		global_rotation = lerp_angle(global_rotation, (target.global_position - global_position).angle(), 0.1)
	else:
		destroy()

	global_position += Vector2.RIGHT.rotated(global_rotation) * speed * delta


func on_collision(body: Node):
	# if body != target:
	# 	return
	body.harm(damage)
	body.knockback(global_position - Vector2(100, 0).rotated(global_rotation), damage)
	destroy()

func destroy():
	set_physics_process(false)
	$Particles.emitting = false
	ParticleTimer.create_timer(self, [$Particles]).then(self, "queue_free")
