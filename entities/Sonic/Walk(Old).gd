extends BasicState




func Enter(_msg := {}) -> void:
	owner.AnimTree.set("parameters/Run/blend_amount", -1.0)
	owner.AnimTree.set("parameters/TSWalk/scale", owner.Speed * owner.PARAMETERS.MOVE_WALK_ANIM_SPEED_MODIFIER)

	if owner.velocity.length() > 0.0 and owner.velocity.normalized() != Vector3.UP:
		owner.CharMesh.look_at(owner.global_position + owner.velocity.normalized())


func Exit() -> void:
	owner.GroundCast.target_position = Vector3.DOWN * owner.GroundCastLength


func Update(_delta: float) -> void:
	var vel : Vector3 = owner.velocity.normalized()
	var speed : float = owner.Speed
	
	if owner.GetInputVector().length() > 0.0:
		var InputVel = owner.GetInputVector()
	
		if owner.up_direction.y < 0.0:
			InputVel = InputVel.rotated(owner.Camera.CurrentBasis.x, deg_to_rad(180.0))
			#InputVel.y = -InputVel.y
	
		vel = (vel + InputVel).normalized()
		
		if speed < owner.PARAMETERS.RUN_MAX_SPEED:
			speed += (owner.GetInputVector().length() * owner.PARAMETERS.RUN_ACCEL_RATE)
		
		owner.CharMesh.look_at(owner.global_position + vel)
	else:
		var groundAngle = owner.up_direction.dot(Vector3.UP)
		
		speed = lerp(speed, 0.0, owner.PARAMETERS.RUN_DECEL_RATE * _delta)
	
	speed = clamp(speed, -owner.PARAMETERS.MOVE_MAX_SPEED, owner.PARAMETERS.MOVE_MAX_SPEED)
	
	owner.SetVelocity(vel * speed)
	owner.Move()
	owner.apply_floor_snap()
	owner.AnimTree.set("parameters/TSWalk/scale", owner.Speed * owner.PARAMETERS.MOVE_WALK_ANIM_SPEED_MODIFIER)
	
	if owner.Speed > owner.PARAMETERS.MOVE_WALK_ANIM_MAX_SPEED:
		ChangeSubState("Run")
		return


func UpdateMoveAnim() -> void:
	if owner.DashMode:
		owner.AnimTree.set("parameters/Run/blend_amount", 1.0)
		owner.AnimTree.set("parameters/TSStrikeDash/scale", owner.Speed * owner.PARAMETERS.MOVE_STRIKEDASH_ANIM_SPEED_MODIFIER)
		return
	
	if owner.Speed < owner.PARAMETERS.MOVE_WALK_ANIM_MAX_SPEED:
		owner.AnimTree.set("parameters/Run/blend_amount", -1.0)
		owner.AnimTree.set("parameters/TSWalk/scale", owner.Speed * owner.PARAMETERS.MOVE_WALK_ANIM_SPEED_MODIFIER)
	elif owner.Speed < owner.PARAMETERS.MOVE_RUN_ANIM_MAX_SPEED:
		owner.AnimTree.set("parameters/Run/blend_amount", 0.0)
		owner.AnimTree.set("parameters/TSRun/scale", owner.Speed * owner.PARAMETERS.MOVE_RUN_ANIM_SPEED_MODIFIER)

