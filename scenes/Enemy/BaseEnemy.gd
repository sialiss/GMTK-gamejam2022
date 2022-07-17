extends RigidBody2D
class_name Enemy

export var health = 1
export var damage = 10

# Places the newly spawned enemy at the location
func set_location(location: Node2D):
	pass

# Deals damage to the enemy
func harm(damage: float):
	health = max(health - damage, 0)
	if health <= 0:
		Score.score += 1
		queue_free()
