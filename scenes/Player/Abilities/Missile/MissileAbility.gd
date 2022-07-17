extends Ability

onready var game = get_node("../../..")

export(PackedScene) var missile_scene
export(int) var amount = 3
export(float) var duration = 1.0

var shots_fired = 0

func _ready():
	$Area.connect("body_entered", self, "shoot")
	Ticker.once(self, duration).then(self, "detach")

func shoot(body: Node):
	count_shot()
	if shots_fired > amount:
		return

	yield(get_tree(), "physics_frame")
	var missile = missile_scene.instance()
	game.add_child_below_node(game.get_node("CanvasLayer"), missile)
	missile.global_position = global_position
	missile.set_target(body)

func count_shot():
	shots_fired += 1
	if shots_fired >= amount:
		detach()
