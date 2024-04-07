extends Node3D



func SetToCollision(_collision: KinematicCollision3D) -> void:
	$CollisionPoint.global_position = _collision.get_position()
	$CollisionNormal.mesh = ImmediateMesh.new()
	$CollisionNormal.mesh.surface_begin(Mesh.PRIMITIVE_LINES, preload("res://entities/Collision/new_standard_material_3d.tres"))
	$CollisionNormal.mesh.surface_set_color(Color.RED)
	$CollisionNormal.mesh.surface_add_vertex(_collision.get_position())
	$CollisionNormal.mesh.surface_add_vertex(_collision.get_position() + _collision.get_normal())
	$CollisionNormal.mesh.surface_end()
	$CollisionNormalCap.global_position = _collision.get_position() + _collision.get_normal()
	
	#$CollisionNormal.look_at(_collision.get_normal())
	#print(_collision.get_normal())


func _on_timer_timeout():
	queue_free()
