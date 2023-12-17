extends Label


@onready var StickPosition = $Background/Control/Position

const MaxRange = 38.0

func Update(input: Vector2) -> void:
	StickPosition.position = input * MaxRange
