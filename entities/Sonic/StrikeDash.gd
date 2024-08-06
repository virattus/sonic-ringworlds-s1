extends "res://entities/Sonic/MoveGround.gd"



func Enter(_msg := {}) -> void:
	owner.AnimTree.set("parameters/Movement/blend_amount", 0.0)
	owner.AnimTree.set("parameters/Ground/blend_amount", 1.0)
	owner.AnimTree.set("parameters/GroundSecondary/blend_amount", -1.0)
	owner.AnimTree.set("parameters/Run/blend_amount", 1.0)
	
	owner.ActivateHitbox(true)
	owner.DamageThreshold = owner.PARAMETERS.DAMAGE_THRESHOLD_STRIKEDASH


func Exit() -> void:
	owner.ActivateHitbox(false)
	owner.DamageThreshold = owner.PARAMETERS.DAMAGE_THRESHOLD_NORMAL


func Update(_delta: float) -> void:
	if !HandleMovementAndCollisions(_delta):
		ChangeState("Fall")
		return
	
	
	var inputVel : Vector3 = owner.GetInputVector(owner.up_direction)
	
	var newVel : Vector3 = owner.velocity
	
	newVel += inputVel * owner.PARAMETERS.RUN_SPEED_POWER * _delta
	
	newVel = ApplyDrag(newVel, _delta)
	
	owner.SetVelocity(newVel)
	
	if !owner.DashMode:
		ChangeState("Run")
		return
