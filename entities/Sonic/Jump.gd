extends "res://entities/Sonic/MoveAir.gd"




func Enter(_msg := {}) -> void:
	owner.AnimTree.set("parameters/Movement/blend_amount", 1.0)
	owner.AnimTree.set("parameters/Air/blend_amount", -1.0)
	
	owner.GroundCollision = false
	owner.HasJumped = true
	
	owner.SndJump.play()
	
	#TODO get this thing to use the model's forward direction for velocity
	#owner.velocity = owner.velocity * owner.CharMesh.GetForwardVector()
	owner.velocity += owner.up_direction * owner.PARAMETERS.JUMP_POWER


func Exit() -> void:
	pass


func Update(_delta: float) -> void:
	owner.Move()
	
	if !HandleCollisions():
		return
	
	if Input.is_action_just_pressed("Jump"):
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
	
	if owner.velocity.y < 0.0:
		ChangeState("Fall")
		return
	
	owner.ApplyGravity(_delta)
