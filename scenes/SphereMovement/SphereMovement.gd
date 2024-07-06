extends Node3D


@onready var Cam = %Camera3D
@onready var CamPivot = %CameraPivot
@onready var Player = $TestChar



func _physics_process(delta: float) -> void:
	if Player.Cam.global_basis != CamPivot.global_basis:
		assert(false)
	
	#Cam.look_at($TestChar.global_position)
