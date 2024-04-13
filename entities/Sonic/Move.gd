extends BasicState



var LastFrameVelocity := Vector3.ZERO

func Enter(_msg := {}) -> void:
	owner.AnimTree.set("parameters/Movement/blend_amount", 0.0)
	owner.AnimTree.set("parameters/Ground/blend_amount", 1.0)
	owner.AnimTree.set("parameters/GroundSecondary/blend_amount", -1.0)
	
	UpdateMoveAnim()
	
	if owner.velocity.length() > 0.0:
		owner.CharMesh.look_at(owner.global_position + owner.velocity.normalized())
	
	LastFrameVelocity = owner.velocity
	


func Exit() -> void:
	owner.GroundCast.target_position = Vector3.DOWN * owner.GroundCastLength


func Update(_delta: float) -> void:
	var vel : Vector3 = owner.velocity.normalized()
	var speed : float = owner.Speed
	
	if owner.Controller.InputVelocity.length() > 0.0:
		if speed >= owner.PARAMETERS.SKID_MIN_REQUIRED_SPEED and IsInputSkidding():
			ChangeState("Skid")
			return
		
		var InputVel = owner.Controller.InputVelocity
		
		var floorBasis = owner.Camera.get_node("SpringArm3D/Camera3D").transform.basis
		floorBasis = basis_aligned_y(floorBasis, owner.up_direction)
		
		InputVel = floorBasis * InputVel
		
		
	
		vel = (vel + InputVel).normalized()
		
		if speed < owner.PARAMETERS.RUN_MAX_SPEED:
			speed += (owner.Controller.InputVelocity.length() * owner.PARAMETERS.RUN_ACCEL_RATE)
		
		owner.CharMesh.look_at(owner.global_position + vel)
	else:
		var groundAngle = owner.up_direction.dot(Vector3.UP)
		
		speed = lerp(speed, 0.0, owner.PARAMETERS.RUN_DECEL_RATE * _delta)
	
	speed = clamp(speed, -owner.PARAMETERS.MOVE_MAX_SPEED, owner.PARAMETERS.MOVE_MAX_SPEED)
	
	owner.Move(vel * speed)
	owner.CharMesh.AlignToY(owner.up_direction)
	
	UpdateMoveAnim()
	
	LastFrameVelocity = owner.velocity
	
	owner.up_direction = owner.up_direction.slerp(owner.FloorNormal.normalized(), _delta * owner.UP_VEC_LERP_RATE).normalized()
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
		ChangeState("Fall")
		return
		
		
	var DotToGround = owner.up_direction.dot(Vector3.UP)
	if DotToGround < owner.PARAMETERS.MOVE_GROUND_STICK_MIN_ANGLE:
		if owner.Speed < owner.PARAMETERS.MOVE_GROUND_STICK_REQ_SPEED:
			print("Move: Too slow to stick: %s, DotToGround: %s" % [owner.Speed, DotToGround])
			owner.velocity += owner.up_direction * owner.PARAMETERS.MOVE_GRIP_LOST_EJECTION_MAGNITUDE
			ChangeState("Fall", {
				"CanStick": false,
			})
			return
	
	if Input.is_action_just_pressed("DEBUG_ForceSkid"):
		ChangeState("Wipeout")
		return
	
	if Input.is_action_just_pressed("Jump"):
		ChangeState("Jump")
		return
	
	if Input.is_action_just_pressed("Attack"):
		ChangeState("Ball")
		return
	
	
	if owner.Speed <= owner.PARAMETERS.MOVE_MIN_SPEED:
		ChangeState("Idle")
		return


func UpdateMoveAnim() -> void:
	if owner.StrikeDash:
		owner.AnimTree.set("parameters/Run/blend_amount", 1.0)
		owner.AnimTree.set("parameters/TSStrikeDash/scale", owner.Speed * owner.PARAMETERS.MOVE_STRIKEDASH_ANIM_SPEED_MODIFIER)
		return
	
	if owner.Speed < owner.PARAMETERS.MOVE_WALK_ANIM_MAX_SPEED:
		owner.AnimTree.set("parameters/Run/blend_amount", -1.0)
		owner.AnimTree.set("parameters/TSWalk/scale", owner.Speed * owner.PARAMETERS.MOVE_WALK_ANIM_SPEED_MODIFIER)
	elif owner.Speed < owner.PARAMETERS.MOVE_RUN_ANIM_MAX_SPEED:
		owner.AnimTree.set("parameters/Run/blend_amount", 0.0)
		owner.AnimTree.set("parameters/TSRun/scale", owner.Speed * owner.PARAMETERS.MOVE_RUN_ANIM_SPEED_MODIFIER)


func IsInputSkidding() -> bool:
	if owner.Controller.InputVelocity.length() > owner.PARAMETERS.SKID_INPUT_MIN:
		var InputDir = LastFrameVelocity.normalized().dot(owner.Controller.InputVelocity.normalized())
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


