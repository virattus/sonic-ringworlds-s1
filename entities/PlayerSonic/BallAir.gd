extends "res://entities/Player/MoveAir.gd"



func Enter(_msg := {}) -> void:
	owner.SonicModel.visible = false
	owner.SonicBall.visible = true
	owner.ActivateHitbox(true)
	owner.DamageThreshold = owner.Parameters.DAMAGE_THRESHOLD_BALL
	
	owner.GroundCollision = false
	
	if _msg.has("PlayChargeSound") and _msg["PlayChargeSound"]:
		owner.SndSpinCharge.play()



func Exit() -> void:
	owner.SonicModel.visible = true
	owner.SonicBall.visible = false
	owner.ActivateHitbox(false)


func Update(_delta: float) -> void:
	owner.Move()
	
	var collision: SonicCollision = owner.GetCollision()
	owner.GroundCollision = CheckGroundCollision(collision)
	
	if owner.GroundCollision:
		ChangeState("Ball")
		return

	var newVel = owner.velocity

	var inputVel = owner.GetInputVector(owner.up_direction)

	newVel = ApplyAirDrag(newVel, _delta / 2.0)
	newVel = owner.ApplyGravity(newVel, _delta)
	
	owner.SetVelocity(newVel)



func ApplyAirDrag(vel: Vector3, delta: float) -> Vector3:
	vel.x = lerp(vel.x, 0.0, delta)
	vel.z = lerp(vel.z, 0.0, delta)
	
	return vel
