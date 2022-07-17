extends Enemy

onready var Visibility = $VisibilityNotifier2D

export var step_size = Vector2(48, 43)
export var step_interval = 0.5
export var step_duration = 0.5

func _ready():
	IdleStatus.new().attach(self)


func set_location(location: Node2D):
	# snap position to step grid
	global_position.x = stepify(location.global_position.x, step_size.x)
	global_position.y = stepify(location.global_position.y, step_size.y)

# Overriden to remove knockback
func knockback(from: Vector2, damage: float):
	if StatusMachina.find(self) is DeathStatus:
		.knockback(from, damage)

func die():
	DeathStatus.new().attach(self)

class IdleStatus:
	extends Status

	func _ready():
		Ticker.once(self, host.step_interval).then(self, "step")

	func step():
		StepStatus.new().attach(host)

class StepStatus:
	extends Status

	func _ready():
		if not host.get_parent().has_node("Player"):
			return
		var player = host.get_node("../Player")

		var player_pos = player.global_position

		var direction = host.global_position.direction_to(player_pos)
		var angle = direction.angle() + rand_range(-TAU/4, TAU/4)
		angle = stepify(angle, TAU/4)
		var new_position = host.global_position + Vector2.RIGHT.rotated(angle)*host.step_size
		new_position.x = stepify(new_position.x, host.step_size.x)
		new_position.y = stepify(new_position.y, host.step_size.y)

		var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC).set_parallel(true)
		tween.tween_property(host, "global_position", new_position, host.step_duration)
		tween.tween_property(host, "global_rotation", 0.0, host.step_duration)
		tween.chain().tween_callback(self, "stop")

	func stop():
		if host.Visibility.is_on_screen():
			IdleStatus.new().attach(host)
		else:
			host.queue_free()

class DeathStatus:
	extends Status

	func _ready():
		$"../CollisionShape2D".set_deferred("disabled", true)
		var tween = create_tween()
		tween.tween_property(host, "modulate", Color.transparent, 0.5)
		tween.tween_callback(host, "queue_free")
