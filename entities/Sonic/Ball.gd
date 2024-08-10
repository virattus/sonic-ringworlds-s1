extends "res://entities/Sonic/MoveGround.gd"




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
	
	
	if owner.GroundCollision and owner.Speed < owner.PARAMETERS.BALL_MIN_SPEED:
		UncurlAndIdle()
		return
	
	if !owner.GroundCollision:
		owner.ApplyGravity(_delta)
		
	var newVel = owner.velocity
	
	var inputVel = owner.GetInputVector(owner.up_direction)
	
	if inputVel.length() > 0.0:
		newVel += inputVel * owner.PARAMETERS.WALK_SPEED_POWER * _delta
	else:
		newVel = ApplyDrag(newVel, _delta / 2.0)
	
	var influence = CurveInfluence(_delta)
		
	if influence.length() <= 0.05 and newVel.length() < owner.PARAMETERS.BALL_MIN_SPEED:
		UncurlAndIdle()
		return
	
	newVel += influence
	
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
	
