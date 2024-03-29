extends Enemy

func set_location(location: Node2D):
	# Set the mob's direction perpendicular to the path direction.
	var direction = location.global_rotation + PI / 2

	# Set the mob's position to a random location.
	global_position = location.global_position

	# Add some randomness to the direction.
	direction += rand_range(-PI / 4, PI / 4)
	rotation = direction

	# Choose the velocity
	var velocity = Vector2(rand_range(150.0, 250.0), 0.0)
	linear_velocity = velocity.rotated(direction)

func _process(delta):
	$HatOrigin.global_rotation = 0
	$HatOrigin/EnemyHatDisplay.display3d.set_hat_rotation(global_rotation)

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func die():
	$CollisionShape2D.set_deferred("disabled", true)
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color.transparent, 0.5)
	tween.tween_callback(self, "queue_free")
