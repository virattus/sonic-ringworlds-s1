extends "res://effects/Decal/Decal.gd"


@export var TargetRay : RayCast3D


func _process(_delta: float) -> void:
	if TargetRay:
		TargetRay.force_raycast_update()
		UpdateWithRaycast(TargetRay)
