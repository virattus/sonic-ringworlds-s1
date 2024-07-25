extends "res://entities/Sonic/MoveAir.gd"



func Enter(_msg := {}) -> void:
	owner.AnimTree.set("parameters/AirSpinKick/blend_amount", 1.0)
	
	owner.ActivateHitbox(true)


func Exit() -> void:
	pass


func Update(_delta: float) -> void:
	pass
