extends "res://entities/Sonic/MoveAir.gd"




func Enter(_msg := {}) -> void:
	owner.AnimTree.set("parameters/Movement/blend_amount", 1.0)
	owner.AnimTree.set("parameters/Air/blend_amount", -1.0)
	
	owner.GroundCollision = false
	owner.HasJumped = true
	
	owner.SndJump.play()
	
	print("Jumped")

	#Set velocity to only forward direction + jump direction, fixes bug with jumping after circling sphere
	owner.SetVelocity((owner.velocity * abs(owner.CharMesh.GetForwardVector())) + (owner.up_direction * owner.PARAMETERS.JUMP_POWER))


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
	
	var inputVel : Vector3 = owner.GetInputVector(owner.up_direction)
	
	var newVel : Vector3 = owner.velocity
	
	newVel += inputVel * _delta
	
	newVel = owner.ApplyGravity(newVel, _delta)
	
	owner.SetVelocity(newVel)
