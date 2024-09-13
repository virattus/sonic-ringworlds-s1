class_name GameCamera
extends Node3D


@onready var Cam : Camera3D = $SpringArm3D/Camera3D


func GetBasis() -> Basis:
	return Cam.global_basis
