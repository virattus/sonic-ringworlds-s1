extends Node2D


@onready var Icons = [
	$FlickyIcon1,
	$FlickyIcon2,
	$FlickyIcon3,
	$FlickyIcon4,
	$FlickyIcon5,
]


func ActivateIcon(IconID: int) -> void:
	assert(IconID >= 0)
	assert(IconID < 5)
	Icons[IconID].Activate()
