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
	print("Осталось %d здоровья" % health)
	$Health.move_pawn(change)
