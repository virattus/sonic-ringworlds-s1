class_name CameraFocus
extends Node3D


@export var Target : Character



func _physics_process(delta: float) -> void:
	assert(Target)
	global_position = Target.global_position
