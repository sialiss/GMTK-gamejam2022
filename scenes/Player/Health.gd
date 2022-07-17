extends CanvasLayer

onready var pawn = $Pawn

# Called when the node enters the scene tree for the first time.
func _ready():
	pawn.global_position.x = $StartPosition.global_position.x
	pawn.global_position.y = $StartPosition.global_position.y

func move_pawn(change: float):
	var step = change * 4.8
	var new_position = $Pawn.global_position + Vector2(step, 0)
	new_position.x = clamp(new_position.x, $StartPosition.global_position.x, $EndPosition.global_position.x)
	var tween = create_tween().set_ease(Tween.EASE_OUT)
	tween.tween_property($Pawn, "global_position", new_position, 0.2)
