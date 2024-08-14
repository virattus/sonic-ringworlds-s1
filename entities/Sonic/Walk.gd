extends "res://entities/Sonic/MoveGround.gd"


var SkidStickBelowMagnitude := 0

const SKID_MIN_STICK_MAGNITUDE = 0.6
const SKID_STICK_MAX_MAG_COUNT = 15
const SKID_MAX_ANGLE = 0.15

const MAX_SPEED = 18.0

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
	
	if inputVel.length() < SKID_MIN_STICK_MAGNITUDE:
		SkidStickBelowMagnitude += 1
	else:
		if SkidStickBelowMagnitude > 0 and SkidStickBelowMagnitude < SKID_STICK_MAX_MAG_COUNT:
			if IsInputSkidding(inputVel):
				ChangeState("Skid")
				return
		else:
			SkidStickBelowMagnitude = 0
	
	if inputVel.length() > 0.0:
		var inputValue : Vector3 = (inputVel * owner.PARAMETERS.WALK_SPEED_POWER * _delta) + (inputVel.normalized() * owner.Speed)
		newVel = inputValue 
		if newVel.length() > MAX_SPEED:
			newVel = newVel.normalized() * MAX_SPEED
	else:
		newVel = owner.ApplyDrag(newVel, _delta)
	
	
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



func IsInputSkidding(input: Vector3) -> bool:
	var ForwardVector = owner.CharMesh.GetForwardVector()
	var forwardDot = ForwardVector.dot(input.normalized())
	
	if forwardDot < 0.0:
		print("Input skidding? %s" % forwardDot)
		return true
	
	return false
