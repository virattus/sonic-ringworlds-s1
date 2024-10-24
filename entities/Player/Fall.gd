extends "res://entities/Player/MoveAir.gd"




func Enter(_msg := {}) -> void:
	owner.AnimTree.set("parameters/Movement/blend_amount", 1.0)
	owner.AnimTree.set("parameters/Air/blend_amount", 0.0)
	
	owner.GroundCollision = false
	owner.StickToFloor = false


func Exit() -> void:
	pass


func Update(_delta: float) -> void:
	owner.Move()
	
	var collision : CharCollision = owner.GetCollision()
	if CheckGroundCollision(collision):
		#Landed
		return

	if Input.is_action_just_pressed("Jump"):
		if !HandleJumpInput():
			return
	
	if Input.is_action_just_pressed("Attack"):
		if !HandleAttackInput():
			return


	owner.CharMesh.AlignToY(owner.up_direction)

	if owner.IsUnderwater:
		owner.UpdateUpDir(Vector3.UP, _delta)

	var newVel : Vector3 = owner.velocity
	
	newVel = HandleAirInput(newVel, _delta)
	
	if !owner.CanJump and Input.is_action_just_released("Jump"):
		if newVel.y > owner.Parameters.JUMP_RELEASE_MAX_Y_SPEED:
			newVel.y = owner.Parameters.JUMP_RELEASE_MAX_Y_SPEED
	
	#newVel = ApplyAirDrag(newVel, _delta)
	newVel = owner.ApplyGravity(newVel, _delta)
	
	
	if newVel.length() > owner.Parameters.MOVE_MAX_SPEED:
		newVel = newVel.normalized() * owner.Parameters.MOVE_MAX_SPEED

	OldVel = owner.velocity
	owner.SetVelocity(newVel)



func HandleJumpInput() -> bool:
	if owner.IsUnderwater:
		ChangeState("Jump")
		return false
	return true


func HandleAttackInput() -> bool:
	return true
