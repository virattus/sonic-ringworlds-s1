extends "res://entities/Sonic/MoveAir.gd"




func Enter(_msg := {}) -> void:
	owner.AnimTree.set("parameters/Movement/blend_amount", 1.0)
	owner.AnimTree.set("parameters/Air/blend_amount", 0.0)
	
	owner.GroundCollision = false


func Exit() -> void:
	pass


func Update(_delta: float) -> void:
	owner.Move()
	
	if HandleCollisions():
		return

	if Input.is_action_just_pressed("Jump"):
		ChangeState("Airdash")
		return

	var inputVel = owner.GetInputVector(Vector3.UP)
	
	owner.ApplyGravity(_delta)
	var newVel = owner.velocity
	
	newVel += inputVel * _delta
	
	newVel = ApplyDrag(newVel, _delta)

	owner.SetVelocity(newVel)

