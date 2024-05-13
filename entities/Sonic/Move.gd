extends ComplexState





func Enter(_msg := {}) -> void:
	owner.AnimTree.set("parameters/Movement/blend_amount", 0.0)
	owner.AnimTree.set("parameters/Ground/blend_amount", 1.0)
	owner.AnimTree.set("parameters/GroundSecondary/blend_amount", -1.0)
	
	if owner.DashMode:
		_msg["SubState"] = "StrikeDash"
	
	super(_msg)


func Exit() -> void:
	super()


func Update(_delta: float) -> void:
	if owner.Controller.InputVelocity.length() > 0.0:
		if owner.Speed >= owner.PARAMETERS.SKID_MIN_REQUIRED_SPEED and IsInputSkidding():
			ChangeState("Skid")
			return
	
	super(_delta)

	owner.CharMesh.AlignToY(owner.up_direction)

	owner.up_direction = owner.up_direction.normalized().slerp(owner.FloorNormal.normalized(), _delta * owner.UP_VEC_LERP_RATE)
	owner.CharGroundCast.target_position = -owner.FloorNormal.normalized() * owner.CharGroundCastLength
	owner.GroundCast.target_position = -owner.FloorNormal.normalized() * owner.GroundCastLength
	
	var groundCollision := false
	var groundDot = owner.FloorNormal.dot(Vector3.UP)
	#print("groundDot: ", groundDot)
	
	if owner.is_on_floor():
		owner.FloorNormal = owner.get_floor_normal()
		groundCollision = true
	else:
		owner.CharGroundCast.force_raycast_update()
		if owner.CharGroundCast.is_colliding():
			var dot : float = owner.FloorNormal.dot(owner.CharGroundCast.get_collision_normal())
			if dot > owner.PARAMETERS.MOVE_FLOOR_NORMAL_DOT_MIN:
				if owner.global_position.distance_to(owner.CharGroundCast.get_collision_point()) < owner.PARAMETERS.MOVE_RAYCAST_SNAP_MAX_DISTANCE:
					owner.FloorNormal = owner.CharGroundCast.get_collision_normal()
					owner.global_position = owner.CharGroundCast.get_collision_point() + (owner.CharGroundCast.get_collision_normal() * 0.5)
					groundCollision = true
				else:
					print("Move: raycast found floor, but distance too great: ", owner.global_position.distance_to(owner.CharGroundCast.get_collision_point()))
			else:
				print("Move: Found floor with raycast, but dot product is ", dot)
	
	if !groundCollision:
		ChangeState("Air", {
			"SubState": "Fall",
			"AirVel": owner.velocity + (owner.FloorNormal * 1.0),
		})
		return
		
		
	var DotToGround = owner.up_direction.dot(Vector3.UP)
	if DotToGround < owner.PARAMETERS.MOVE_GROUND_STICK_MIN_ANGLE:
		if owner.Speed < owner.PARAMETERS.MOVE_GROUND_STICK_REQ_SPEED:
			print("Move: Too slow to stick: %s, DotToGround: %s" % [owner.Speed, DotToGround])
			owner.velocity += owner.up_direction * owner.PARAMETERS.MOVE_GRIP_LOST_EJECTION_MAGNITUDE
			ChangeState("Air", {
				"SubState": "Fall",
				"AirVel": owner.velocity + (owner.FloorNormal * 1.0),
			})
			return
	
	if Input.is_action_just_pressed("DEBUG_ForceSkid"):
		ChangeState("Wipeout")
		return
	
	if Input.is_action_just_pressed("Jump"):
		ChangeState("Air", {
			"SubState": "Jump",
		})
		return
	
	if Input.is_action_just_pressed("Attack"):
		ChangeState("Ball")
		return
	
	if owner.Speed <= owner.PARAMETERS.MOVE_MIN_SPEED:
		ChangeState("Idle")
		return



func IsInputSkidding() -> bool:
	if owner.Controller.InputVelocity.length() > owner.PARAMETERS.SKID_INPUT_MIN:
		var InputDir = owner.velocity.normalized().dot(owner.Controller.InputVelocity.normalized())
		if InputDir < owner.PARAMETERS.SKID_ANGLE_MIN:
			print("Move: Skid ratio: %s" % InputDir)
			return true
		
	return false


func basis_aligned_x(basis_to_align: Basis, vector_to_align_with: Vector3) -> Basis:
	basis_to_align.x = vector_to_align_with
	basis_to_align.y = basis_to_align.z.cross(basis_to_align.y)
	basis_to_align = basis_to_align.orthonormalized()
	return basis_to_align


func basis_aligned_y(basis_to_align: Basis, vector_to_align_with: Vector3) -> Basis:
	basis_to_align.y = vector_to_align_with
	basis_to_align.x = -basis_to_align.z.cross(basis_to_align.y)
	basis_to_align = basis_to_align.orthonormalized()
	return basis_to_align
