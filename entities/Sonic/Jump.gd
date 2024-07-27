extends "res://entities/Sonic/MoveAir.gd"




func Enter(_msg := {}) -> void:
	owner.AnimTree.set("parameters/Movement/blend_amount", 1.0)
	owner.AnimTree.set("parameters/Air/blend_amount", -1.0)
	
	owner.GroundCollision = false
	
	owner.SndJump.play()
	
	owner.CharMesh.AlignToY(owner.FloorNormal)


func Exit() -> void:
	pass


func Update(_delta: float) -> void:
	pass
