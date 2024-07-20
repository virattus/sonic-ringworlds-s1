extends BasicState



func Enter(_msg := {}) -> void:
	owner.AnimTree.set("parameters/Movement/blend_amount", 0.0)
	owner.AnimTree.set("parameters/Ground/blend_amount", 1.0)
	owner.AnimTree.set("parameters/GroundSecondary/blend_amount", 1.0)
	
	owner.SndSkid.play()
	
	owner.SetVelocity(owner.velocity.normalized() * owner.PARAMETERS.SKID_START_SPEED)


func Exit() -> void:
	owner.SndSkid.stop()


func Update(_delta: float) -> void:
	owner.velocity = lerp(owner.velocity, Vector3.ZERO, owner.PARAMETERS.SKID_SPEED_REDUCTION_RATE * _delta)
	
	owner.Move(owner.velocity)
	
	owner.up_direction = owner.up_direction.slerp(owner.FloorNormal.normalized(), _delta * owner.UP_VEC_LERP_RATE).normalized()
	owner.CharGroundCast.target_position = -(owner.FloorNormal.normalized()) * owner.CharGroundCastLength
	
	if owner.is_on_floor():
		owner.FloorNormal = owner.get_floor_normal()
	else:
		owner.CharGroundCast.force_raycast_update()
		if owner.CharGroundCast.is_colliding():
			var dot : float = owner.FloorNormal.dot(owner.CharGroundCast.get_collision_normal())
			if dot > owner.PARAMETERS.MOVE_FLOOR_NORMAL_DOT_MIN:
				if owner.global_position.distance_to(owner.CharGroundCast.get_collision_point()) < owner.PARAMETERS.MOVE_RAYCAST_SNAP_MAX_DISTANCE:
					owner.FloorNormal = owner.CharGroundCast.get_collision_normal()
					owner.global_position = owner.CharGroundCast.get_collision_point() + (owner.CharGroundCast.get_collision_normal() * 0.5)
				else:
					print("Skid: raycast found floor, but distance too great: ", owner.global_position.distance_to(owner.CharGroundCast.get_collision_point()))
					owner.GroundCollision = false
			else:
				print("Skid: Found floor with raycast, but dot product is ", dot)
				owner.GroundCollision = false
		else:
			print("Skid: ground cast failed to find ground")
			owner.GroundCollision = false
	
	if !owner.GroundCollision:
		ChangeState("Fall", {
		})
		return
	
	if owner.Speed <= owner.PARAMETERS.SKID_END_MIN_SPEED:
		ChangeState("Idle")
		return
 
