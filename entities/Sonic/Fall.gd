extends "res://entities/Sonic/MoveAir.gd"




func Enter(_msg := {}) -> void:
	owner.AnimTree.set("parameters/Movement/blend_amount", 1.0)
	owner.AnimTree.set("parameters/Air/blend_amount", 0.0)
	
	owner.GroundCollision = false
	owner.StickToFloor = false


func Exit() -> void:
	pass


func Update(_delta: float) -> void:
	owner.Move()
	
	var collision : SonicCollision = owner.GetCollision()
	if CheckGroundCollision(collision):
		#Landed
		return

	if Input.is_action_just_pressed("Jump"):
		if owner.IsUnderwater:
			ChangeState("Jump")
			return
		else:
			if Input.is_action_just_pressed("Attack"):
				ChangeState("Pose")
				return
			else:
				ChangeState("Airdash")
				return
	
	if Input.is_action_just_pressed("Attack"):
		if owner.DashMode:
			ChangeState("SpinKick")
			return
		else:
			ChangeState("Ball")
			return


	owner.CharMesh.AlignToY(owner.up_direction)

	if owner.IsUnderwater:
		owner.UpdateUpDir(Vector3.UP, _delta)

	var newVel : Vector3 = owner.velocity
	var newSpeed : float = owner.Speed
	
	var inputVel = owner.GetInputVector(Vector3.UP)
	newVel += inputVel * owner.PARAMETERS.AIR_INPUT_VEL * _delta
	
	newVel = newVel.normalized() * newSpeed
	
	#newVel = ApplyDrag(newVel, _delta)
	newVel = owner.ApplyGravity(newVel, _delta)
	
	if newVel.length() > owner.PARAMETERS.MOVE_MAX_SPEED:
		newVel = newVel.normalized() * owner.PARAMETERS.MOVE_MAX_SPEED

	OldVel = owner.velocity
	owner.SetVelocity(newVel)
