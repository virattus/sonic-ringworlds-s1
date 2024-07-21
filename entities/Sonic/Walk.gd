extends "res://entities/Sonic/MoveGround.gd"



const WALK_INPUT_SPEED_MOD = 0.05


func Enter(_msg := {}) -> void:
	owner.AnimTree.set("parameters/Run/blend_amount", -1.0)
	owner.AnimTree.set("parameters/TSWalk/scale", owner.Speed * owner.PARAMETERS.MOVE_WALK_ANIM_SPEED_MODIFIER)

	if owner.velocity.length() > 0.0 and owner.velocity.normalized() != Vector3.UP:
		owner.CharMesh.look_at(owner.global_position + owner.velocity.normalized())


func Exit() -> void:
	pass


func Update(_delta: float) -> void:
	owner.Move()
	owner.apply_floor_snap()
	
	owner.CharMesh.AlignToY(owner.up_direction)
	owner.AnimTree.set("parameters/TSWalk/scale", owner.Speed * owner.PARAMETERS.MOVE_WALK_ANIM_SPEED_MODIFIER)
	
	#if owner.Speed >= 
	
	var newVel = owner.velocity
	
	var inputVel = owner.GetInputVector()
	
	if inputVel.length() >= 0.0:
		owner.CharMesh.look_at(owner.global_position + owner.velocity)
	else:
		newVel = ApplyDrag(newVel, _delta)
		
	var newSpeed = newVel.length() + (inputVel.length() * WALK_INPUT_SPEED_MOD)
	
	newVel = inputVel.normalized() * newSpeed
	
	
	owner.SetVelocity(newVel)
	
	
	if owner.Speed <= 0.0:
		ChangeState("Idle")
		return
	
	if owner.Speed > owner.PARAMETERS.MOVE_WALK_ANIM_MAX_SPEED:
		ChangeState("Run")
		return
