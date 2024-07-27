extends "res://entities/Sonic/MoveGround.gd"



const GROUND_NORMAL_TRANSITION_MIN = 0.75
const GROUND_NORMAL_HOP = 0.1

const WALK_SPEED_POWER = 20.0
const WALK_ANIM_SPEED_MOD = 1.0


func Enter(_msg := {}) -> void:
	owner.AnimTree.set("parameters/Movement/blend_amount", 0.0)
	owner.AnimTree.set("parameters/Ground/blend_amount", 1.0)
	owner.AnimTree.set("parameters/GroundSecondary/blend_amount", -1.0)
	owner.AnimTree.set("parameters/Run/blend_amount", -1.0)


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
				if owner.up_direction.dot(collision.CollisionNormal) < GROUND_NORMAL_TRANSITION_MIN:
					#Too large of an angle to transition
					owner.SetVelocity(owner.velocity + (owner.up_direction * GROUND_NORMAL_HOP))
					ChangeState("Fall")
					return
	else:
		ChangeState("Fall")
		return
	
	var newVel = owner.velocity
	
	#only update model's direction if player moves stick
	if inputVel.length() > 0.0:
		owner.CharMesh.look_at(owner.global_position + newVel.normalized())
	
	newVel += inputVel * WALK_SPEED_POWER * _delta
	
	newVel = ApplyDrag(newVel, _delta)
	
	owner.SetVelocity(newVel)


func UpdateAnim() -> void:
	owner.CharMesh.AlignToY(owner.up_direction)
	owner.AnimTree.set("parameters/TSWalk/scale", owner.Speed * WALK_ANIM_SPEED_MOD)
