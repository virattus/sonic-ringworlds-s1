extends "res://entities/Sonic/MoveGround.gd"


const SKID_DRAG_COEFF = 3.0
const SKID_MOVEMENT_SPEED = 10.0
const SKID_TRANSITION_MIN_SPEED = 1.0


func Enter(_msg := {}) -> void:
	owner.AnimTree.set("parameters/Movement/blend_amount", 0.0)
	owner.AnimTree.set("parameters/Ground/blend_amount", 1.0)
	owner.AnimTree.set("parameters/GroundSecondary/blend_amount", 1.0)
	
	owner.SndSkid.play()
	
	owner.SetVelocity(owner.velocity.normalized() * SKID_MOVEMENT_SPEED)


func Exit() -> void:
	owner.SndSkid.stop()


func Update(_delta: float) -> void:
	owner.Move()
	
	var collision: SonicCollision = owner.GetCollision()
	
	if collision.CollisionType == SonicCollision.NONE:
		ChangeState("Fall")
		return
	
	if owner.Speed < SKID_TRANSITION_MIN_SPEED:
		ChangeState("Idle")
		return
	
	var newVel = owner.velocity
	newVel = ApplyDrag(newVel, SKID_DRAG_COEFF * _delta)
	
	owner.SetVelocity(newVel)
	
 
