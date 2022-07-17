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
		die()

func knockback(from: Node2D, damage: float):
	var v = (self.global_position - from.global_position)
	var direction = v.normalized()
	var force = 200000 / v.length()
	apply_impulse((-direction + Vector2(randf(),randf()))*32, direction * force)

func die():
	queue_free()