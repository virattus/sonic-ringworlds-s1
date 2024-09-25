class_name CameraFocus
extends Node3D


@export var Target : Character


func _ready() -> void:
	assert(Target)


func _physics_process(delta: float) -> void:
	global_position = Target.global_position
