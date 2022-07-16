extends Spatial

onready var mesh: MeshInstance = $"%Mesh"
onready var target_transform: Transform = mesh.transform.translated(Vector3.ZERO)
var tween: SceneTreeTween

func rotate_left():
	_turn(Vector3.FORWARD, -TAU/4)
func rotate_right():
	_turn(Vector3.FORWARD, TAU/4)
func rotate_up():
	_turn(Vector3.RIGHT, -TAU/4)
func rotate_down():
	_turn(Vector3.RIGHT, TAU/4)

func _turn(axel: Vector3, angle: float):
	target_transform = target_transform.rotated(axel, angle)
	if tween:
		tween.kill()
	tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(mesh, "transform", target_transform, 0.5)
