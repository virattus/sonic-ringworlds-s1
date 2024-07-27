extends "res://entities/Sonic/MoveGround.gd"


const WIPEOUT_MIN_SPEED = 1.0


func Enter(_msg := {}) -> void:
	owner.AnimTree.set("parameters/Movement/blend_amount", 0.0)
	owner.AnimTree.set("parameters/Ground/blend_amount", 1.0)
	owner.AnimTree.set("parameters/GroundSecondary/blend_amount", 0.0)
	
	owner.CameraFocus.position = Vector3(0, 0.5, 0)
	
	owner.SndSkid.play()



func Exit() -> void:
	owner.SndSkid.stop()


func Update(_delta: float) -> void:
	owner.Move()

	if owner.Speed < WIPEOUT_MIN_SPEED:
		ChangeState("Idle")
		return

	owner.SetVelocity(ApplyDrag(owner.velocity, _delta))
	
