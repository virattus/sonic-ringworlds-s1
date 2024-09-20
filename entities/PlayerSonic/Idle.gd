extends "res://entities/Player/MoveGround.gd"



func Enter(_msg := {}) -> void:
	owner.AnimTree.set("parameters/Movement/blend_amount", 0.0)
	owner.AnimTree.set("parameters/Ground/blend_amount", 0.0)
	owner.AnimTree.set("parameters/GroundSecondary/blend_amount", -1.0)
	owner.AnimTree.set("parameters/Idle/blend_amount", 0.0)

	owner.SetVelocity(Vector3.ZERO)


func Exit() -> void:
	pass


func Update(_delta: float) -> void:
	if !HandleMovementAndCollisions(_delta):
		ChangeState("Fall")
		return
	
	if Input.is_action_just_pressed("Jump"):
		ChangeState("Jump")
		return
	
	if Input.is_action_just_pressed("Attack"):
		ChangeState("SquatCharge")
		return
	
	var newVel : Vector3 = owner.velocity
	
	newVel += CurveInfluence(_delta)
	
	var inputVel : Vector3 = owner.GetInputVector(owner.up_direction)
	
	newVel += inputVel * owner.Parameters.WALK_SPEED_POWER
	
	if newVel.length() > owner.Parameters.IDLE_MAX_SPEED:
		owner.SetVelocity(newVel)
		ChangeState("Move")
		return
