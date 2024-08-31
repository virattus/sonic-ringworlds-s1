extends "res://entities/Sonic/MoveGround.gd"



const RUN_SKID_MIN_STICK_MAGNITUDE = 0.6
const RUN_SKID_MAX_ANGLE = -0.15


func Enter(_msg := {}) -> void:
	owner.AnimTree.set("parameters/Movement/blend_amount", 0.0)
	owner.AnimTree.set("parameters/Ground/blend_amount", 1.0)
	owner.AnimTree.set("parameters/GroundSecondary/blend_amount", -1.0)


func Exit() -> void:
	pass
	

func Update(_delta: float) -> void:
	if !HandleMovementAndCollisions(_delta):
		ChangeState("Fall")
		return
	
	UpdateMoveAnimations()
	
	if Input.is_action_just_pressed("Jump"):
		ChangeState("Jump")
		return
	
	if Input.is_action_just_pressed("Attack"):
		ChangeState("Ball")
		return
	
	var newVel = owner.velocity
	
	var inputVel = owner.GetInputVector(owner.up_direction)
	
	if inputVel.length() > 0.0:
		if newVel.length() > owner.PARAMETERS.WALK_MAX_SPEED:
			if HandleSkid(inputVel):
				return
			else:
				newVel = CalculateRunVelocity(inputVel, _delta)
		else:
			newVel = CalculateWalkVelocity(inputVel, _delta)
	else:
		newVel = owner.ApplyDrag(newVel, _delta)
	
	if newVel.length() > owner.PARAMETERS.MOVE_MAX_SPEED:
		newVel = newVel.normalized() * owner.PARAMETERS.MOVE_MAX_SPEED
	
	
	if inputVel.length() > 0.0:
		#only update model's direction if player moves stick
		owner.OrientCharMesh()
		#if owner.Speed > owner.PARAMETERS.WALK_MAX_SPEED:
		#	ChangeState("Run")
		#	return
	else:
		var influence = CurveInfluence(_delta)
		
		if influence.length() <= 0.05 and newVel.length() <= owner.PARAMETERS.IDLE_MAX_SPEED:
			ChangeState("Idle")
			return
		
		newVel += influence
		
		if newVel.length() > 2.0:
			if owner.CharMesh.GetForwardVector().dot(newVel.normalized()) > 0.0:
				owner.CharMesh.LerpMeshOrientation(newVel.normalized(), _delta)
			else:
				owner.CharMesh.LerpMeshOrientation(-newVel.normalized(), _delta)
		
	owner.SetVelocity(newVel)


func CalculateWalkVelocity(inputVel: Vector3, delta: float) -> Vector3:
	var inputValue : Vector3 = (inputVel * owner.PARAMETERS.WALK_SPEED_POWER * delta) + (inputVel.normalized() * owner.Speed)
	var newVel = inputValue
	
	return newVel


func CalculateRunVelocity(inputVel: Vector3, delta: float) -> Vector3:
	var newVel = owner.velocity
	
	var ratio = owner.Speed / owner.PARAMETERS.MOVE_MAX_SPEED
	
	var newSpeed = (newVel + (inputVel * owner.PARAMETERS.RUN_SPEED_POWER * delta)).length()
	
	newVel = (newVel * ratio) + ((inputVel * owner.PARAMETERS.RUN_SPEED_POWER * delta) * (1.0 - ratio))
	
	newVel = newVel.normalized() * newSpeed
	
	newVel = owner.ApplyDrag(newVel, delta)
	
	#Remove excess velocity for curves/spheres
	newVel = newVel - (owner.up_direction * owner.up_direction.dot(newVel))
	
	return newVel


func HandleSkid(input: Vector3) -> bool:
	if input.length() > RUN_SKID_MIN_STICK_MAGNITUDE:
		if IsInputSkidding(input):
			ChangeState("Skid")
			return true
	
	return false


func IsInputSkidding(input: Vector3) -> bool:
	var ForwardVector = owner.CharMesh.GetForwardVector()
	var forwardDot = ForwardVector.dot(input.normalized())
	
	if forwardDot < RUN_SKID_MAX_ANGLE:
		print("Input skidding? %s" % forwardDot)
		return true
	
	return false
