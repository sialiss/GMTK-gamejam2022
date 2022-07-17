extends KinematicBody2D

# Signals
signal hit

# Children
onready var cube_display = $CubeDisplay/Viewport/CubeDisplay3D
onready var ability_timer = $AbilityTimer

# Exports
export var stepX = 94
export var stepY = 85
export(Array, PackedScene) var abilities = []

# Variables


# States

class IdleStatus:
	extends Status

	func _process(_delta):
		var new_position = Vector2.ZERO
		if Input.is_action_pressed("move_right"):
			new_position = host.global_position + Vector2(host.stepX, 0)
			host.cube_display.rotate_right()
			MovingStatus.new(new_position).attach(host)

		elif Input.is_action_pressed("move_left"):
			new_position = host.global_position + Vector2(-host.stepX, 0)
			host.cube_display.rotate_left()
			MovingStatus.new(new_position).attach(host)

		elif Input.is_action_pressed("move_down"):
			new_position = host.global_position + Vector2(0, host.stepY)
			host.cube_display.rotate_down()
			MovingStatus.new(new_position).attach(host)

		elif Input.is_action_pressed("move_up"):
			new_position = host.global_position + Vector2(0, -host.stepY)
			host.cube_display.rotate_up()
			MovingStatus.new(new_position).attach(host)


class MovingStatus:
	extends Status
	var new_position

	func _init(position):
		new_position = position

	func _ready():
		if host.get_viewport_rect().has_point(new_position):
			var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
			tween.tween_property(host, "global_position", new_position, 0.5)
			tween.tween_callback(IdleStatus.new(), "attach", [host])
		else:
			Ticker.once(self, 0.5).then(IdleStatus.new(), "attach", [host])


# Methods

# Called when the node enters the scene tree for the first time.
func _ready():
	IdleStatus.new().attach(self)
	hide()

# Called when the game is starting
func start(pos: Vector2):
	# snap position to step grid
	global_position.x = stepify(pos.x, stepX)
	global_position.y = stepify(pos.y, stepY)

	show()
	ability_timer.start()
	$CollisionShape2D.disabled = false

# Called when touched an enemy
func _on_Area2D_body_entered(_body):
	# hide() # Player disappears after being hit.
	emit_signal("hit")

func use_ability():
	var ability_id = cube_display.get_number()
	if ability_id == 0:
		return

	if ability_id <= abilities.size():
		var ability = abilities[ability_id-1]
		if ability is PackedScene:
			ability.instance().attach(self)
