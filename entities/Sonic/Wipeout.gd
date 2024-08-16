extends "res://entities/Sonic/MoveGround.gd"


const WIPEOUT_START_SPEED = 5.0
const WIPEOUT_MIN_SPEED = 1.0


func Enter(_msg := {}) -> void:
	owner.AnimTree.set("parameters/Movement/blend_amount", 0.0)
	owner.AnimTree.set("parameters/Ground/blend_amount", 1.0)
	owner.AnimTree.set("parameters/GroundSecondary/blend_amount", 0.0)
	
	owner.CameraFocus.position = Vector3(0, 0.5, 0)
	
	owner.SndSkid.play()
	
	owner.SetVelocity(owner.velocity.normalized() * WIPEOUT_START_SPEED)
	owner.CharMesh.LookAt(owner.velocity.normalized())



func Exit() -> void:
	owner.SndSkid.stop()


func Update(_delta: float) -> void:
	if !HandleMovementAndCollisions(_delta):
		ChangeState("Fall")
		return

	if owner.Speed < WIPEOUT_MIN_SPEED:
		ChangeState("Idle")
		return

	var newVel = owner.velocity
	
	newVel = owner.ApplyDrag(newVel, _delta)

	owner.SetVelocity(newVel)
	
