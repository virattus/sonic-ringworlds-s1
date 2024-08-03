extends "res://entities/Sonic/MoveGround.gd"


var SkidStickBelowMagnitude := 0

const RUN_SKID_MIN_STICK_MAGNITUDE = 0.6
const RUN_SKID_STICK_MAX_MAG_COUNT = 15

func Enter(_msg := {}) -> void:
	owner.AnimTree.set("parameters/Movement/blend_amount", 0.0)
	owner.AnimTree.set("parameters/Ground/blend_amount", 1.0)
	owner.AnimTree.set("parameters/GroundSecondary/blend_amount", -1.0)


func Exit() -> void:
	SkidStickBelowMagnitude = 0


func Update(_delta: float) -> void:
	if !HandleMovementAndCollisions(_delta):
		ChangeState("Fall")
		return
	
	var inputVel = owner.GetInputVector(owner.up_direction)
	
	if !WallRunMinVelocity():
		return
	
	if Input.is_action_just_pressed("Jump"):
		ChangeState("Jump")
		return
	
	if Input.is_action_just_pressed("Attack"):
		ChangeState("Ball")
		return
	
	
	if inputVel.length() < RUN_SKID_MIN_STICK_MAGNITUDE:
		SkidStickBelowMagnitude += 1
	else:
		if SkidStickBelowMagnitude > 0 and SkidStickBelowMagnitude < RUN_SKID_STICK_MAX_MAG_COUNT:
			if IsInputSkidding(inputVel):
				ChangeState("Skid")
				return
		else:
			SkidStickBelowMagnitude = 0

	
	var newVel = owner.velocity
	
	newVel += inputVel * owner.PARAMETERS.RUN_SPEED_POWER * _delta
	
	newVel = ApplyDrag(newVel, _delta)
	
	owner.SetVelocity(newVel)
	
	
	if inputVel.length() > 0.0:
		#only update model's direction if player moves stick
		owner.CharMesh.look_at(owner.global_position + newVel.normalized())
		pass
	if owner.Speed <= owner.PARAMETERS.WALK_MAX_SPEED:
		ChangeState("Walk")
		return


func IsInputSkidding(input: Vector3) -> bool:
	var ForwardVector = owner.CharMesh.GetForwardVector()
	var forwardDot = ForwardVector.dot(input.normalized())
	
	if forwardDot < 0.0:
		print("Input skidding? %s" % forwardDot)
		return true
	
	return false
