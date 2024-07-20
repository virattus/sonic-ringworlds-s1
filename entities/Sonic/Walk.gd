extends "res://entities/Sonic/MoveGround.gd"



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
	
	#if owner.Speed >= 
	
	var newVel = owner.velocity
	
	var inputVel = owner.GetInputVector()
	
	owner.SetVelocity(owner.velocity + inputVel)
	
	
	if owner.Speed <= 0.0:
		ChangeState("Idle")
		return
	
