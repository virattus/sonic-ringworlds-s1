extends "res://entities/Sonic/MoveGround.gd"




func Enter(_msg := {}) -> void:
	owner.AnimTree.set("parameters/Movement/blend_amount", 0.0)
	owner.AnimTree.set("parameters/Ground/blend_amount", 1.0)
	owner.AnimTree.set("parameters/GroundSecondary/blend_amount", -1.0)
	UpdateAnim()


func Exit() -> void:
	pass


func Update(_delta: float) -> void:
	owner.Move()
	
	UpdateAnim()
	
	var inputVel = owner.GetInputVector(owner.up_direction)
	
	var collision: SonicCollision = owner.GetCollision()
	
	if collision.CollisionType != SonicCollision.NONE:
		if collision.CollisionType == SonicCollision.CEILING:
			pass
		else:
			owner.UpdateDebugIndicators(inputVel.normalized(), collision.CollisionNormal)
			owner.UpdateUpDir(collision.CollisionNormal, _delta)
			if collision.CollisionType == SonicCollision.FLOOR:
				if owner.up_direction.dot(collision.CollisionNormal) < owner.PARAMETERS.GROUND_NORMAL_TRANSITION_MIN:
					#Too large of an angle to transition
					owner.SetVelocity(owner.velocity + (owner.up_direction * owner.PARAMETERS.GROUND_NORMAL_HOP))
					ChangeState("Fall")
					return
	else:
		ChangeState("Fall")
		return
	
	if Input.is_action_just_pressed("Jump"):
		ChangeState("Jump")
		return
	
	var newVel = owner.velocity
	
	newVel += inputVel * owner.PARAMETERS.RUN_SPEED_POWER * _delta
	
	newVel = ApplyDrag(newVel, _delta)
	
	owner.SetVelocity(newVel)
	
	
	if inputVel.length() > 0.0:
		#only update model's direction if player moves stick
		#owner.CharMesh.look_at(owner.global_position + inputVel.normalized())
		pass
	if owner.Speed <= owner.PARAMETERS.WALK_MAX_SPEED:
		ChangeState("Walk")
		return


func UpdateAnim() -> void:
	if owner.Speed > owner.PARAMETERS.RUN_MAX_SPEED:
		owner.AnimTree.set("parameters/Run/blend_amount", 1.0)
		owner.AnimTree.set("parameters/TSSprint/scale", owner.Speed * owner.PARAMETERS.SPRINT_ANIM_SPEED_MOD)
	else:
		owner.AnimTree.set("parameters/Run/blend_amount", 0.0)
		owner.AnimTree.set("parameters/TSRun/scale", owner.Speed * owner.PARAMETERS.RUN_ANIM_SPEED_MOD)
