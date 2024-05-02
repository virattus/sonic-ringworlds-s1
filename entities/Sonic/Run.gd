extends BasicState




func Enter(_msg := {}) -> void:
	owner.AnimTree.set("parameters/Run/blend_amount", 0.0)
	owner.AnimTree.set("parameters/TSRun/scale", owner.Speed * owner.PARAMETERS.MOVE_RUN_ANIM_SPEED_MODIFIER)


func Exit() -> void:
	pass


func Update(_delta: float) -> void:
	var vel : Vector3 = owner.velocity.normalized()
	var speed : float = owner.Speed
	
	if owner.Controller.InputVelocity.length() > 0.0:
		var InputVel = owner.Controller.InputVelocity
	
		if owner.up_direction.y < 0.0:
			InputVel = InputVel.rotated(owner.Camera.CurrentBasis.x, deg_to_rad(180.0))
	
		vel = (vel + InputVel).normalized()
		
		if speed < owner.PARAMETERS.RUN_MAX_SPEED:
			speed += (owner.Controller.InputVelocity.length() * owner.PARAMETERS.RUN_ACCEL_RATE)
		
		owner.CharMesh.look_at(owner.global_position + vel)
	else:
		var groundAngle = owner.up_direction.dot(Vector3.UP)
		
		speed = lerp(speed, 0.0, owner.PARAMETERS.RUN_DECEL_RATE * _delta)
	
	speed = clamp(speed, -owner.PARAMETERS.MOVE_MAX_SPEED, owner.PARAMETERS.MOVE_MAX_SPEED)
	
	owner.Move(vel * speed)
	owner.AnimTree.set("parameters/TSRun/scale", owner.Speed * owner.PARAMETERS.MOVE_RUN_ANIM_SPEED_MODIFIER)
