extends Node
class_name ParticleTimer

signal timeout

export(Array, NodePath) var particles = []

func _ready():
	var particle_nodes = []
	for i in particles.size():
		particle_nodes.append(get_node(particles[i]))

	create_timer(self, particle_nodes).then(self, "_finish")

func _finish():
	emit_signal("timeout")

static func create_timer(host: Node, particle_nodes: Array):
	var duration = 0
	for particle in particle_nodes:
		var d = particle.lifetime * (2 - particle.explosiveness)
		if d > duration:
			duration = d

	return Ticker.once(host, duration)