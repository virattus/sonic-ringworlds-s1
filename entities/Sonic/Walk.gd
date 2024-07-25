extends "res://entities/Sonic/MoveGround.gd"



const WALK_INPUT_SPEED_MOD = 0.05


func Enter(_msg := {}) -> void:
	owner.AnimTree.set("parameters/Movement/blend_amount", 0.0)
	owner.AnimTree.set("parameters/Ground/blend_amount", 1.0)
	owner.AnimTree.set("parameters/GroundSecondary/blend_amount", -1.0)
	owner.AnimTree.set("parameters/Run/blend_amount", -1.0)
	owner.AnimTree.set("parameters/TSWalk/scale", owner.Speed * owner.PARAMETERS.MOVE_WALK_ANIM_SPEED_MODIFIER)

	if owner.Speed > 0.0 and owner.velocity.normalized() != Vector3.UP:
		owner.CharMesh.look_at(owner.global_position + owner.velocity.normalized())


func Exit() -> void:
	pass


func Update(_delta: float) -> void:
	owner.Move()
	owner.apply_floor_snap()
	
	owner.GroundCollision = owner.CollisionDetection(0, 0)
	
	owner.CharMesh.AlignToY(owner.up_direction)
	if owner.velocity != Vector3.ZERO and owner.velocity.normalized() != Vector3.UP:
		owner.CharMesh.look_at(owner.global_position + owner.velocity.normalized())
	owner.AnimTree.set("parameters/TSWalk/scale", owner.Speed * owner.PARAMETERS.MOVE_WALK_ANIM_SPEED_MODIFIER)
	
	
	var newVel = owner.velocity
	var newSpeed = newVel.length()
	
	var inputVel = owner.GetInputVector()
	
	if inputVel.length() > 0.0:
		newSpeed += inputVel.length() * WALK_INPUT_SPEED_MOD
		newVel = inputVel.normalized() * newSpeed
	else:
		newVel = ApplyDrag(newVel, _delta)
	
	owner.SetVelocity(newVel)
	
	if owner.Speed <= 0.0:
		ChangeState("Idle")
		return
	
	if owner.Speed > owner.PARAMETERS.MOVE_WALK_ANIM_MAX_SPEED:
		ChangeState("Run")
		return
