extends CharacterBody3D


@export var Direction := Vector3.UP
@export var Speed := 1.0

var Accumulator := 0.0

@onready var StartingPos = global_position


func _process(delta: float) -> void:
	global_position = StartingPos + (Direction * sin(Accumulator))
	
	Accumulator += delta

