extends "res://effects/Decal/Decal.gd"



@export var TargetRay = RayCast3D.new()


func _process(_delta: float) -> void:
	TargetRay.force_raycast_update()
	UpdateWithRaycast(TargetRay)
