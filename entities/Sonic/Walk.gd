extends "res://entities/Sonic/MoveGround.gd"



const GROUND_NORMAL_TRANSITION_MIN = 0.75
const GROUND_NORMAL_HOP = 0.1


func Enter(_msg := {}) -> void:
	owner.AnimTree.set("parameters/Movement/blend_amount", 0.0)
	owner.AnimTree.set("parameters/Ground/blend_amount", 1.0)
	owner.AnimTree.set("parameters/GroundSecondary/blend_amount", -1.0)
	owner.AnimTree.set("parameters/Run/blend_amount", -1.0)


func Exit() -> void:
	pass


func Update(_delta: float) -> void:
	owner.Move()
	owner.apply_floor_snap()
	
	UpdateAnim()
	
	var inputVel = owner.GetInputVector(owner.up_direction)
	
	var collision: SonicCollision = owner.GetCollision()
	
	if collision.CollisionType != SonicCollision.NONE:
		if collision.CollisionType == SonicCollision.CEILING:
			pass
		else:
			owner.UpdateUpDir(collision.CollisionNormal, _delta)
			if collision.CollisionType == SonicCollision.FLOOR:
				if owner.up_direction.dot(collision.CollisionNormal) < GROUND_NORMAL_TRANSITION_MIN:
					#Too large of an angle to transition
					owner.SetVelocity(owner.velocity + (owner.up_direction * GROUND_NORMAL_HOP))
					ChangeState("Fall")
					return
	else:
		ChangeState("Fall")
		return
	
	if Input.is_action_just_pressed("Jump"):
		ChangeState("Jump")
		return
	
	var newVel = owner.velocity
	
	if inputVel.length() > 0.0:
		newVel = (inputVel * owner.PARAMETERS.WALK_SPEED_POWER * _delta) + (inputVel.normalized() * owner.Speed)
	else:
		newVel = ApplyDrag(newVel, _delta)
	
	owner.SetVelocity(newVel)
	
	
	if inputVel.length() > 0.0:
		#only update model's direction if player moves stick
		owner.CharMesh.look_at(owner.global_position + newVel.normalized())
		if owner.Speed > owner.PARAMETERS.WALK_MAX_SPEED:
			ChangeState("Run")
			return
	else:
		if owner.Speed <= owner.PARAMETERS.WALK_MIN_SPEED:
			ChangeState("Idle")
			return


func UpdateAnim() -> void:
	owner.CharMesh.AlignToY(owner.up_direction)
	owner.AnimTree.set("parameters/TSWalk/scale", owner.Speed * owner.PARAMETERS.WALK_ANIM_SPEED_MOD)
