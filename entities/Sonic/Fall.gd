extends "res://entities/Sonic/MoveAir.gd"




func Enter(_msg := {}) -> void:
	owner.AnimTree.set("parameters/Air/blend_amount", 0.0)


func Exit() -> void:
	pass


func Update(_delta: float) -> void:
	owner.Move()
	
	#TODO angles
	if owner.CollisionDetection(0.0, 0.0):
		ChangeState("Land")
		return
	
	var newVel = owner.velocity
	
	newVel += owner.GetInputVector()
	
	newVel = ApplyGravity(newVel, _delta)
	newVel = ApplyDrag(newVel, _delta)
	
	owner.SetVelocity(newVel)
