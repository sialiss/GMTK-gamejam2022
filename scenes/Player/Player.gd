extends KinematicBody2D
signal hit

export var stepX = 94
export var stepY = 85

# Attack variables
var attack_cooldown_time = 100
var next_attack_time = 0

onready var cube_display = $CubeDisplay/Viewport/CubeDisplay3D

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
	var screen_size

	func _init(position):
		new_position = position

	func _ready():
		if host.get_viewport_rect().has_point(new_position):
			var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
			tween.tween_property(host, "global_position", new_position, 0.5)
			tween.tween_callback(IdleStatus.new(), "attach", [host])
		else:
			Ticker.once(self, 0.5).then(IdleStatus.new(), "attach", [host])
		
# Called when the node enters the scene tree for the first time.
func _ready():
	IdleStatus.new().attach(self)
	hide()

func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false

func _on_Area2D_body_entered(_body):
	# hide() # Player disappears after being hit.
	emit_signal("hit")
