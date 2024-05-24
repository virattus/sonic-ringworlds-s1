extends Node3D


@onready var Cam = %Camera3D



func _physics_process(delta: float) -> void:
	Cam.look_at($TestChar.global_position)
