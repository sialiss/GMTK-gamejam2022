extends Node
class_name ParticleTimer

signal timeout

export(Array, NodePath) var particles = []

func _ready():
	var particle_nodes = []
	for i in particles.size():
		particle_nodes.append(get_node(particles[i]))

	var duration = 0
	for particle in particle_nodes:
		var d = particle.lifetime * (2 - particle.explosiveness)
		if d > duration:
			duration = d

	Ticker.once(self, duration).then(self, "_finish")

func _finish():
	emit_signal("timeout")
