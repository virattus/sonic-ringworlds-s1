extends "res://entities/Sonic/MoveAir.gd"




func Enter(_msg := {}) -> void:
	owner.AnimTree.set("parameters/Movement/blend_amount", 1.0)
	owner.AnimTree.set("parameters/Air/blend_amount", -1.0)
	
	owner.GroundCollision = false
	owner.HasJumped = true
	
	owner.SndJump.play()
	
	print("Jumped")

	var newVel : Vector3 = owner.velocity
	
	#Set velocity to only forward direction + jump direction, fixes bug with jumping after circling sphere
	#thanks to https://gamedev.stackexchange.com/questions/198103/how-can-i-zero-out-velocity-in-an-arbitrary-direction
	#Up direction should be normalised, but not newVel
	newVel = newVel - (owner.up_direction * owner.up_direction.dot(newVel))
	
	newVel += owner.up_direction * owner.PARAMETERS.JUMP_POWER
	
	owner.SetVelocity(newVel)


func Exit() -> void:
	pass


func Update(_delta: float) -> void:
	owner.Move()
	
	var collision : SonicCollision = owner.GetCollision()
	if CheckGroundCollision(collision):
		#We landed while travelling up, this should probably never happen
		return
	
	if Input.is_action_just_pressed("Jump"):
		if Input.is_action_just_pressed("Attack"):
			ChangeState("Pose")
			return
		else:
			ChangeState("Airdash")
			return
	
	if Input.is_action_just_pressed("Attack"):
		if !owner.DashMode:
			ChangeState("SpinKick")
			return
		else:
			ChangeState("Ball")
			return
	
	if owner.velocity.y < 0.0:
		ChangeState("Fall")
		return
	
	var newVel : Vector3 = owner.velocity
	
	var inputVel : Vector3 = owner.GetInputVector(owner.up_direction)
	newVel += inputVel * owner.PARAMETERS.AIR_INPUT_MOD * _delta
	
	newVel = owner.ApplyGravity(newVel, _delta)
	
	owner.SetVelocity(newVel)
