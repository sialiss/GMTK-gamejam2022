extends CanvasLayer

onready var pawn = $Pawn

# Called when the node enters the scene tree for the first time.
func _ready():
	pawn.global_position.x = $StartPosition.global_position.x
	pawn.global_position.y = $StartPosition.global_position.y

func move_pawn(change: float):
	var step = change * 4.8
	$Pawn.global_position.x = clamp($Pawn.global_position.x + step, $StartPosition.global_position.x, $EndPosition.global_position.x)
