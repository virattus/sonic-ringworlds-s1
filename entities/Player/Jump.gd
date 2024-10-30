extends "res://entities/Player/MoveAir.gd"


#If the player jumps while upside down, the state will change immediately to negative,
#this just sets a minimum time to be jumping
var JumpTimeAccumulator := 0.0

const MIN_JUMP_TIME = 1.5


func Enter(_msg := {}) -> void:
	owner.AnimTree.set("parameters/Movement/blend_amount", 1.0)
	owner.AnimTree.set("parameters/Air/blend_amount", -1.0)
	
	if _msg.has("JumpSound") and _msg["JumpSound"]:
		owner.SndJump.play()
	
	var JumpForce = owner.Parameters.JUMP_POWER
	
	if _msg.has("JumpForce"):
		JumpForce = _msg["JumpForce"]
	
	if owner.IsUnderwater:
		JumpForce *= 0.5
	
	if _msg.has("JumpDirection"):
		owner.up_direction = _msg["JumpDirection"]
		owner.CharMesh.AlignToY(owner.up_direction)

	var newVel : Vector3 = owner.TrueVelocity
	if _msg.has("IgnoreVel") and _msg["IgnoreVel"]:
		newVel = Vector3.ZERO
	
	#Set velocity to only forward direction + jump direction, fixes bug with jumping after circling sphere
	#thanks to https://gamedev.stackexchange.com/questions/198103/how-can-i-zero-out-velocity-in-an-arbitrary-direction
	#Up direction should be normalised, but not newVel
	var frontVel = newVel - (owner.up_direction * owner.up_direction.dot(newVel))
	newVel = frontVel + owner.up_direction * JumpForce
	
	owner.SetTrueVelocity(newVel)
	owner.SetVelocity(newVel)
	
	owner.CharMesh.LookAt(owner.global_position + frontVel.normalized())
	owner.CharMesh.AlignToY(owner.up_direction)
	
	owner.GroundCollision = false
	owner.StickToFloor = false
	
	print("Jumped")


func Exit() -> void:
	JumpTimeAccumulator = 0.0


func Update(_delta: float) -> void:
	owner.Move()
	
	var collision : CharCollision = owner.GetCollision()
	if collision.CollisionType == CharCollision.CEILING:
		if owner.CanHang and Input.is_action_pressed("Jump"):
			#We might be able to hang, see if it's possible
			if AbleToHang():
				ChangeState("Hang")
				return
			
	if CheckGroundCollision(collision):
		return
	
	if Input.is_action_just_pressed("Jump"):
		if !HandleJumpInput():
			return
	
	if Input.is_action_just_pressed("Attack"):
		if !HandleAttackInput():
			return
	
	JumpTimeAccumulator += _delta
	
	if owner.velocity.y < 0.0:
		if owner.up_direction.dot(Vector3.UP) > 0.0:
			ChangeState("Fall")
			return
		elif JumpTimeAccumulator > MIN_JUMP_TIME:
			ChangeState("Fall")
			return

	
	owner.CharMesh.AlignToY(owner.up_direction)
	
	if owner.IsUnderwater:
		owner.UpdateUpDir(Vector3.UP, _delta)
	
	var newVel : Vector3 = owner.TrueVelocity
	
	newVel = HandleAirInput(newVel, _delta)
	
	if !owner.CanJump and Input.is_action_just_released("Jump"):
		if newVel.y > owner.Parameters.JUMP_RELEASE_MAX_Y_SPEED:
			newVel.y = owner.Parameters.JUMP_RELEASE_MAX_Y_SPEED

	
	#if newVel.y > 0.0 and newVel.y < 4.0:
	#	newVel = ApplyAirDrag(newVel, _delta)
	newVel = owner.ApplyGravity(newVel, _delta)
	
	owner.SetTrueVelocity(newVel)
	owner.SetVelocity(newVel)


func HandleJumpInput() -> bool:
	if owner.IsUnderwater:
		ChangeState("Jump")
		return false
	return true


func HandleAttackInput() -> bool:
	return true


func AbleToHang() -> bool:
	return true
