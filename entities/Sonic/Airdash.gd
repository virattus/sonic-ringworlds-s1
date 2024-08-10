extends "res://entities/Sonic/MoveAir.gd"


const AIRDASH_FORWARD_SPEED = 25.0
const AIRDASH_DRAG_COEFF = 1.5
const AIRDASH_MIN_REQ_SPEED = 2.0


func Enter(_msg := {}) -> void:
	owner.AnimTree.set("parameters/Movement/blend_amount", 1.0)
	owner.AnimTree.set("parameters/Air/blend_amount", 1.0)
	
	owner.AirdashTrail.Active = true
	
	owner.SndAirdash.play()
	
	owner.SetVelocity(owner.velocity.normalized() * AIRDASH_FORWARD_SPEED)

	owner.UpdateUpDir(Vector3.UP, 1.0)


func Exit() -> void:
	owner.AirdashTrail.Active = false
	owner.SndAirdash.stop()


func Update(_delta: float) -> void:
	owner.Move()
	
	if HandleCollisions():
		return
	
	if (owner.velocity * Vector3(1, 0, 1)).length() <= AIRDASH_MIN_REQ_SPEED:
		ChangeState("Fall")
		return
	
	owner.ApplyGravity(_delta)
	var newVel = owner.velocity
	newVel = ApplyDrag(owner.velocity, _delta * AIRDASH_DRAG_COEFF)
	
	owner.SetVelocity(newVel)
