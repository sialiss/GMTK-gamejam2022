extends RigidBody2D

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite.playing = true
	var mob_types = $AnimatedSprite.frames.get_animation_names()
	$AnimatedSprite.animation = mob_types[randi() % mob_types.size()]

func _process(delta):
	$HatOrigin.global_rotation = 0
	$HatOrigin/EnemyHatDisplay.display3d.set_hat_rotation(global_rotation)

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
