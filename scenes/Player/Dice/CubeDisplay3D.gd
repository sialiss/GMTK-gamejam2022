extends Spatial

onready var mesh: MeshInstance = $"%Mesh"
onready var target_transform: Transform = mesh.transform.translated(Vector3.ZERO)
var tween: SceneTreeTween

# func rotate_left():
# 	_turn(Vector3.FORWARD, -TAU/4)
# func rotate_right():
# 	_turn(Vector3.FORWARD, TAU/4)
# func rotate_up():
# 	_turn(Vector3.RIGHT, -TAU/4)
# func rotate_down():
# 	_turn(Vector3.RIGHT, TAU/4)

func rotate_to(direction: Vector2):
	var axel = Vector3(direction.y, 0, -direction.x)
	_turn(axel, TAU/4)

func _turn(axel: Vector3, angle: float):
	target_transform = target_transform.rotated(axel, angle).orthonormalized()
	if tween:
		tween.kill()
	tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(mesh, "transform", target_transform, 0.5)

# Returns the number on the top side of the dice
func get_number():
	var basis = target_transform.basis
	if ( basis.z).is_equal_approx(Vector3.UP): return 1
	if ( basis.x).is_equal_approx(Vector3.UP): return 2
	if ( basis.y).is_equal_approx(Vector3.UP): return 3
	if (-basis.x).is_equal_approx(Vector3.UP): return 4
	if (-basis.y).is_equal_approx(Vector3.UP): return 5
	if (-basis.z).is_equal_approx(Vector3.UP): return 6
	return 0
