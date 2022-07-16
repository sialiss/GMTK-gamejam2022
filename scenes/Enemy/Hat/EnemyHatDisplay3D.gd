extends Spatial

onready var mesh = $Mesh
onready var base_basis = mesh.global_transform.translated(Vector3.ZERO).basis

func set_hat_rotation(radians: float):
	mesh.global_transform.basis = base_basis.rotated(Vector3.DOWN, radians)
