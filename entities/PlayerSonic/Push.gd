extends "res://entities/Player/Push.gd"




func Enter(_msg := {}) -> void:
	owner.AnimTree.set("parameters/Movement/blend_amount", 0.0)
	owner.AnimTree.set("parameters/Push/blend_amount", 1.0)


func Exit() -> void:
	owner.AnimTree.set("parameters/Push/blend_amount", 0.0)


func Update(_delta: float) -> void:
	owner.Move()
	
	var inputVel : Vector3 = owner.GetInputVector(owner.up_direction)
	
	if inputVel.length() == 0.0:
		ChangeState("Idle")
		return
	
	
