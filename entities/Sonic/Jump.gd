extends "res://entities/Sonic/MoveAir.gd"




func Enter(_msg := {}) -> void:
	owner.AnimTree.set("parameters/Movement/blend_amount", 1.0)
	owner.AnimTree.set("parameters/Air/blend_amount", -1.0)
	
	owner.GroundCollision = false
	
	owner.SndJump.play()
	
	owner.velocity += owner.up_direction * owner.PARAMETERS.JUMP_POWER


func Exit() -> void:
	pass


func Update(_delta: float) -> void:
	owner.Move()
	
	
	if !HandleCollisions():
		return
	
	if owner.velocity.y < 0.0:
		ChangeState("Fall")
		return
	
	owner.ApplyGravity(_delta)
