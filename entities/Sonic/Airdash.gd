extends "res://entities/Sonic/MoveAir.gd"




func Enter(_msg := {}) -> void:
	owner.AnimTree.set("parameters/Air/blend_amount", 1.0)
	
	owner.AirdashTrail.Active = true
	
	owner.SndAirdash.play()
	
	owner.FloorNormal = Vector3.UP
	owner.up_direction = Vector3.UP


func Exit() -> void:
	pass


func Update(_delta: float) -> void:
	pass
