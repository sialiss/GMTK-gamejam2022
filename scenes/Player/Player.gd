extends KinematicBody2D

# Signals
signal die

# Children
onready var cube_display = $CubeDisplay/Viewport/CubeDisplay3D
onready var ability_timer = $AbilityTimer

# Exports
export var stepX = 94
export var stepY = 85
export(Array, PackedScene) var abilities = []
export var max_health = 100

onready var health = max_health
onready var stepSize = Vector2(stepX, stepY)

# Variables
var direction_buffer = Vector2.ZERO

# States

class IdleStatus:
	extends Status

	func _process(_delta):
		var new_position = Vector2.ZERO

		if not host.direction_buffer.is_equal_approx(Vector2.ZERO):
			MovingStatus.new(host.direction_buffer).attach(host)
			host.direction_buffer = Vector2.ZERO
			return

		if Input.is_action_pressed("move_right"):
			return MovingStatus.new(Vector2(1, 0)).attach(host)
		if Input.is_action_pressed("move_left"):
			return MovingStatus.new(Vector2(-1, 0)).attach(host)
		if Input.is_action_pressed("move_up"):
			return MovingStatus.new(Vector2(0, -1)).attach(host)
		if Input.is_action_pressed("move_down"):
			return MovingStatus.new(Vector2(0, 1)).attach(host)

class MovingStatus:
	extends Status
	var step: Vector2
	var can_premove = false

	func _init(_step):
		step = _step

	func _ready():
		var new_position = host.global_position + step * host.stepSize
		host.cube_display.rotate_to(step)

		if host.get_viewport_rect().has_point(new_position):
			var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
			tween.tween_property(host, "global_position", new_position, .5)
			tween.tween_callback(IdleStatus.new(), "attach", [host])
		else:
			Ticker.once(self, 0.5).then(IdleStatus.new(), "attach", [host])

		Ticker.once(self, 0.3).then(self, "set", ["can_premove", true])

	func _process(delta):
		if not can_premove:
			return

		if Input.is_action_just_pressed("move_right"):
			host.direction_buffer = Vector2(1, 0)
		elif Input.is_action_just_pressed("move_left"):
			host.direction_buffer = Vector2(-1, 0)
		elif Input.is_action_just_pressed("move_up"):
			host.direction_buffer = Vector2(0, -1)
		elif Input.is_action_just_pressed("move_down"):
			host.direction_buffer = Vector2(0, 1)

# Methods

# Called when the node enters the scene tree for the first time.
func _ready():
	IdleStatus.new().attach(self)
	update_bar(0)
	hide()

# Called when the game is starting
func start(pos: Vector2):
	# snap position to step grid
	global_position.x = stepify(pos.x, stepX)
	global_position.y = stepify(pos.y, stepY)

	show()
	ability_timer.start()
	$CollisionShape2D.disabled = false

func heal(hp: float):
	health = clamp(health+hp, 0, max_health)
	update_bar(-hp)

# Called when touched an enemy
func _on_Area2D_body_entered(body):
	health -= body.damage
	update_bar(body.damage)
	if health <= 0:
		die()

func die():
	emit_signal("die")
	queue_free()

func use_ability():
	var ability_id = cube_display.get_number()
	if ability_id == 0:
		return

	if ability_id <= abilities.size():
		var ability = abilities[ability_id-1]
		if ability is PackedScene:
			ability.instance().attach(self)

func update_bar(change: float):
	$Health/HP.text = "%d/%d" % [health, max_health]
	$Health.move_pawn(change)