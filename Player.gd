extends Area2D

export var stepX = 115
export var stepY = 115

var screen_size

class IdleStatus:
	extends Status

	func _process(_delta):
		var new_position = Vector2.ZERO
		if Input.is_action_pressed("move_right"):
			new_position = host.global_position + Vector2(host.stepX, 0)
			MovingStatus.new(new_position).attach(host)
		if Input.is_action_pressed("move_left"):
			new_position = host.global_position + Vector2(-host.stepX, 0)
			MovingStatus.new(new_position).attach(host)
		if Input.is_action_pressed("move_down"):
			new_position = host.global_position + Vector2(0, host.stepY)
			MovingStatus.new(new_position).attach(host)
		if Input.is_action_pressed("move_up"):
			new_position = host.global_position + Vector2(0, -host.stepY)
			MovingStatus.new(new_position).attach(host)		

class MovingStatus:
	extends Status
	var new_position

	func _init(position):
		new_position = position

	func _ready():
		var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
		tween.tween_property(host, "global_position", new_position, 1)
		tween.tween_callback(IdleStatus.new(), "attach", [host])

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	IdleStatus.new().attach(self)
	# hide()

func start(pos):
	position = pos
	# show()
	$CollisionShape2D.disabled = false
