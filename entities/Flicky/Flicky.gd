extends RigidBody3D


var GroundContact := false


func _physics_process(delta: float) -> void:
	if get_viewport().get_camera_3d().is_position_behind(global_position):
		queue_free()
	
	if !GroundContact:
		GroundContact = true
		linear_velocity = Vector3(randf(), 0.0, randf()).normalized() + Vector3(0.0, 3.0, 0.0)
