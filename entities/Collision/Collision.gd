extends Node3D



func SetToCollision(_collision: KinematicCollision3D) -> void:
	SetToVectors(_collision.get_position(), _collision.get_normal())
	

func SetToRaycast(_raycast: RayCast3D) -> void:
	SetToVectors(_raycast.get_collision_point(), _raycast.get_collision_normal())


func SetToVectors(pos: Vector3, norm: Vector3) -> void:
	$CollisionPoint.global_position = pos
	$CollisionNormal.mesh = ImmediateMesh.new()
	$CollisionNormal.mesh.surface_begin(Mesh.PRIMITIVE_LINES, preload("res://entities/Collision/new_standard_material_3d.tres"))
	$CollisionNormal.mesh.surface_set_color(Color.RED)
	$CollisionNormal.mesh.surface_add_vertex(pos)
	$CollisionNormal.mesh.surface_add_vertex(pos + norm)
	$CollisionNormal.mesh.surface_end()
	$CollisionNormalCap.global_position = pos + norm


func _on_timer_timeout():
	queue_free()
