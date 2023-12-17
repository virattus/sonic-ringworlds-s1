extends MeshInstance3D


@export var VerticalOffset := 0.0

var CollisionPoint := Vector3.ZERO
var CollisionNormal := Vector3.ZERO


func UpdateWithRaycast(raycast: RayCast3D) -> void:
	#raycast.force_raycast_update()
	if !raycast.is_colliding():
		visible = false
	else:
		visible = true
		CollisionPoint = raycast.get_collision_point()
		CollisionNormal = raycast.get_collision_normal()
		
		var _scale = scale
		global_transform = AlignWithY(global_transform, CollisionNormal)
		scale = _scale
		global_position = CollisionPoint + (global_transform.basis.y * VerticalOffset)


func AlignWithY(newTransform: Transform3D, newY: Vector3) -> Transform3D:
	newTransform.basis.y = newY
	newTransform.basis.x = -newTransform.basis.z.cross(newY)
	newTransform.basis = newTransform.basis.orthonormalized()
	return newTransform
