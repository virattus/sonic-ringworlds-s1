extends "res://entities/Sonic/MoveGround.gd"



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
	
	var inputVel = owner.GetInputVector(owner.up_direction)
	
	if Input.is_action_just_pressed("Jump"):
		ChangeState("Jump")
		return
	
	if Input.is_action_just_pressed("Attack"):
		ChangeState("Ball")
		return
	
	var newVel = owner.velocity
	
	if inputVel.length() > 0.0:
		newVel = (inputVel * owner.PARAMETERS.WALK_SPEED_POWER * _delta) + (inputVel.normalized() * owner.Speed)
	else:
		newVel = ApplyDrag(newVel, _delta)
	
	owner.SetVelocity(newVel)
	
	
	if inputVel.length() > 0.0:
		#only update model's direction if player moves stick
		owner.CharMesh.look_at(owner.global_position + owner.velocity)
		if owner.Speed > owner.PARAMETERS.WALK_MAX_SPEED:
			ChangeState("Run")
			return
	else:
		if owner.Speed <= owner.PARAMETERS.WALK_MIN_SPEED:
			ChangeState("Idle")
			return
