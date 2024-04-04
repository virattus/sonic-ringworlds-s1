extends BasicState




func Enter(_msg := {}) -> void:
	owner.AnimTree.set("parameters/Movement/blend_amount", 0.0)
	owner.AnimTree.set("parameters/Ground/blend_amount", 1.0)
	owner.AnimTree.set("parameters/GroundSecondary/blend_amount", -1.0)
	owner.AnimTree.set("parameters/Run/blend_amount", 0.0)


func Exit() -> void:
	pass


func Update(_delta: float) -> void:
	var vel = owner.velocity
	
	if owner.Controller.InputVelocity.length() > 0.0:
		var InputVel = (owner.Controller.InputVelocity * owner.PARAMETERS.RUN_INPUT_MAGNITUDE)
		InputVel *= 1.0 - clamp(owner.Speed / owner.PARAMETERS.RUN_MAX_SPEED, 0.0, 1.0)
	
		vel += InputVel
	else:
		vel = lerp(vel, Vector3.ZERO, owner.PARAMETERS.RUN_DECEL_RATE * _delta)
	
	if vel.length() > owner.PARAMETERS.MOVE_MAX_SPEED:
		vel = vel.normalized() * owner.PARAMETERS.MOVE_MAX_SPEED
	
	owner.Move(vel)
	owner.CharMesh.look_at(owner.global_position + owner.velocity.normalized())
	owner.CharMesh.AlignToY(owner.up_direction)
	#owner.CharMesh.LerpMeshOrientation(owner.Controller.InputVelocity.normalized(), _delta)
	owner.up_direction = owner.up_direction.slerp(owner.FloorNormal.normalized(), _delta * owner.UP_VEC_LERP_RATE).normalized()
	owner.CharGroundCast.target_position = -(owner.FloorNormal.normalized()) * owner.CharGroundCastLength
	
	var groundCollision := false
	var groundDot = owner.FloorNormal.dot(Vector3.UP)
	print("groundDot: ", groundDot)
	
	if owner.is_on_floor():
		owner.FloorNormal = owner.get_floor_normal()
		groundCollision = true
	else:
		owner.CharGroundCast.force_raycast_update()
		if owner.CharGroundCast.is_colliding():
			var dist = owner.global_position.distance_to(owner.CharGroundCast.get_collision_point())
			
			
			var dot = owner.FloorNormal.dot(owner.CharGroundCast.get_collision_normal())
			print(dot)
			if dot < owner.PARAMETERS.MOVE_FLOOR_NORMAL_DOT_MAX:
				pass
			else:
				owner.FloorNormal = owner.CharGroundCast.get_collision_normal()
				groundCollision = true
		else:
			pass
	
	
	if !groundCollision:
		ChangeState("Fall")
		return
	#else:
		#owner.up_direction = owner.FloorNormal
		#owner.global_position = owner.CharGroundCast.get_collision_point() + (owner.CharGroundCast.get_collision_normal() * 0.5)
		
	var DotToGround = owner.up_direction.dot(Vector3.UP)
	if DotToGround > owner.PARAMETERS.MOVE_GROUND_STICK_MIN_ANGLE:
		if owner.Speed < owner.PARAMETERS.MOVE_GROUND_STICK_REQ_SPEED:
			print("Too slow to stick: %s, DotToGround: %s" % [owner.Speed, DotToGround])
			ChangeState("Fall", {
				"CanStick": false,
			})
			return
	
	if Input.is_action_just_pressed("Jump"):
		ChangeState("Jump")
		return
	
	if owner.Speed >= owner.PARAMETERS.SKID_MIN_REQUIRED_SPEED and IsInputSkidding():
		ChangeState("Skid")
		return
	
	if owner.Speed <= owner.PARAMETERS.MOVE_MIN_SPEED:
		ChangeState("Idle")
		return



func IsInputSkidding() -> bool:
	if owner.Controller.InputVelocity.length() > owner.PARAMETERS.SKID_INPUT_MIN:
		var InputDir = owner.velocity.normalized().dot(owner.Controller.InputVelocity)
		if InputDir < owner.PARAMETERS.SKID_ANGLE_MIN:
			print("Skid ratio: %s" % InputDir)
			return true
		
	return false
