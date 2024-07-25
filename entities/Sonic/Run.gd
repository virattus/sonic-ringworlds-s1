extends "res://entities/Sonic/MoveGround.gd"



func Enter(_msg := {}) -> void:
	owner.AnimTree.set("parameters/Movement/blend_amount", 0.0)
	owner.AnimTree.set("parameters/Ground/blend_amount", 1.0)
	owner.AnimTree.set("parameters/GroundSecondary/blend_amount", -1.0)
	owner.AnimTree.set("parameters/Run/blend_amount", 0.0)
	owner.AnimTree.set("parameters/TSRun/scale", owner.Speed * owner.PARAMETERS.MOVE_RUN_ANIM_SPEED_MODIFIER)


func Exit() -> void:
	pass


func Update(_delta: float) -> void:
	owner.Move()
	owner.apply_floor_snap()
	
	owner.GroundCollision = owner.CollisionDetection(0, 0)
	
	owner.CharMesh.AlignToY(owner.up_direction)
	owner.AnimTree.set("parameters/TSRun/scale", owner.Speed * owner.PARAMETERS.MOVE_RUN_ANIM_SPEED_MODIFIER)
	
	
	if !owner.GroundCollision:
		ChangeState("Fall")
		return
	
	
	var newVel = owner.velocity
	
	var inputVel = owner.GetInputVector()
	
	newVel += inputVel
	
	if inputVel.length() >= 0.0 and owner.velocity.normalized() != Vector3.UP:
		owner.CharMesh.look_at(owner.global_position + owner.velocity)
	else:
		newVel = ApplyDrag(newVel, _delta)
	
	if newVel.length() > owner.PARAMETERS.RUN_MAX_SPEED:
		newVel = newVel.normalized() * owner.PARAMETERS.RUN_MAX_SPEED
	
	owner.SetVelocity(newVel)
	
	
	
	if Input.is_action_just_pressed("DEBUG_ForceSkid"):
		ChangeState("Wipeout")
		return
	
	if Input.is_action_just_pressed("Jump"):
		ChangeState("Jump", {
		})
		return
	
	if Input.is_action_just_pressed("Attack"):
		ChangeState("Ball")
		return
	
	if owner.Speed <= owner.PARAMETERS.MOVE_MIN_SPEED:
		ChangeState("Idle")
		return
