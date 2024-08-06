extends "res://entities/Sonic/MoveGround.gd"



const BALL_MIN_SPEED = 0.5


func Enter(_msg := {}) -> void:
	owner.SonicModel.visible = false
	owner.SonicBall.visible = true
	owner.ActivateHitbox(true)
	owner.DamageThreshold = owner.PARAMETERS.DAMAGE_THRESHOLD_BALL
	
	owner.SndSpinCharge.play()


func Exit() -> void:
	#owner.CharMesh.LookAt(owner.velocity.normalized())
	owner.SonicModel.visible = true
	owner.SonicBall.visible = false
	owner.ActivateHitbox(false)
	owner.DamageThreshold = owner.PARAMETERS.DAMAGE_THRESHOLD_NORMAL
	
	owner.SndSpinCharge.stop()


func Update(_delta: float) -> void:
	owner.Move()
	owner.apply_floor_snap()
	
	owner.GroundCollision = HandleCollisions(_delta)
	
	
	if owner.GroundCollision and owner.Speed < BALL_MIN_SPEED:
		UncurlAndIdle()
		return
	
	if !owner.GroundCollision:
		owner.ApplyGravity(_delta)
		
	var newVel = owner.velocity
	newVel = ApplyDrag(newVel, _delta)
	
	owner.SetVelocity(newVel)


func AttackHit(_Target: Hurtbox) -> void:
	print("Ball: Hit enemy")
	owner.DashModeCharge += 0.2
	if !owner.GroundCollision:
		owner.velocity.y = owner.PARAMETERS.ATTACK_BOUNCE_POW


func UncurlAndIdle() -> void:
	owner.CharMesh.look_at(owner.global_position + owner.velocity)
	owner.CharMesh.AlignToY(owner.up_direction)
	ChangeState("Idle")
	
