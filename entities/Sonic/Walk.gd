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
	
	if Input.is_action_just_pressed("Jump"):
		ChangeState("Jump")
		return
	
	if Input.is_action_just_pressed("Attack"):
		ChangeState("Ball")
		return
	
	var newVel = owner.velocity
	
	var inputVel = owner.GetInputVector(owner.up_direction)
	
	if inputVel.length() > 0.0:
		newVel = (inputVel * owner.PARAMETERS.WALK_SPEED_POWER * _delta) + (inputVel.normalized() * owner.Speed)
	else:
		newVel = ApplyDrag(newVel, _delta)
	
	
	if inputVel.length() > 0.0:
		#only update model's direction if player moves stick
		owner.OrientCharMesh()
		if owner.Speed > owner.PARAMETERS.WALK_MAX_SPEED:
			ChangeState("Run")
			return
	else:
		var influence = CurveInfluence(_delta)
		
		if influence.length() <= 0.05 and newVel.length() <= owner.PARAMETERS.IDLE_MAX_SPEED:
			ChangeState("Idle")
			return
		
		#if owner.up_direction.y > 0.0:
		newVel += influence
		
	owner.SetVelocity(newVel)
