extends "res://entities/Player/MoveGround.gd"


var SmokeAccumulator := 0.0

const SKID_DRAG_COEFF = 3.0
const SKID_MOVEMENT_SPEED = 10.0
const SKID_TRANSITION_MIN_SPEED = 1.0

const SMOKE_EMIT_RATE = 0.1


func Enter(_msg := {}) -> void:
	owner.AnimTree.set("parameters/Movement/blend_amount", 0.0)
	owner.AnimTree.set("parameters/Ground/blend_amount", 1.0)
	owner.AnimTree.set("parameters/GroundSecondary/blend_amount", 1.0)
	
	owner.SndSkid.play()
	
	owner.SetVelocity(owner.velocity.normalized() * SKID_MOVEMENT_SPEED)
	
	owner.CreateSmoke()
	
	owner.SetDashMode(false)
	
	#failsafe
	$TimerMaxSkid.start()


func Exit() -> void:
	owner.SndSkid.stop()
	$TimerMaxSkid.stop()


func Update(_delta: float) -> void:
	owner.Move()
	
	SmokeAccumulator += _delta
	if SmokeAccumulator >= SMOKE_EMIT_RATE:
		SmokeAccumulator -= SMOKE_EMIT_RATE 
		owner.CreateSmoke()
	
	
	var collision: SonicCollision = owner.GetCollision()
	
	if collision.CollisionType == SonicCollision.NONE:
		ChangeState("Teetering")
		return
	
	if owner.Speed < SKID_TRANSITION_MIN_SPEED:
		ChangeState("Idle")
		return
	
	var newVel = owner.velocity
	
	newVel = owner.ApplyGravity(newVel, _delta)
	newVel = owner.ApplyDrag(newVel, SKID_DRAG_COEFF * _delta)
	
	owner.SetVelocity(newVel)


func _on_tmr_max_skid_timeout() -> void:
	ChangeState("Fall")
