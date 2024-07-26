extends "res://entities/Sonic/MoveAir.gd"




func Enter(_msg := {}) -> void:
	owner.AnimTree.set("parameters/Movement/blend_amount", 1.0)
	owner.AnimTree.set("parameters/Air/blend_amount", 1.0)
	
	owner.AirdashTrail.Active = true
	
	owner.SndAirdash.play()
	
	owner.FloorNormal = Vector3.UP
	owner.up_direction = Vector3.UP


func Exit() -> void:
	owner.AirdashTrail.Active = false
	owner.SndAirdash.stop()


func Update(_delta: float) -> void:
	owner.Move()
	
	owner.GroundCollision = owner.CollisionDetection(0, 0)
	
	if owner.GroundCollision:
		ChangeState("Land")
		return
		
	owner.velocity = ApplyGravity(owner.velocity, _delta)
	owner.velocity = ApplyDrag(owner.velocity, _delta)
