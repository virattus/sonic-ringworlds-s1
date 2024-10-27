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
	
	var collision: CharCollision = owner.GetCollision()
	owner.GroundCollision = CheckGroundCollision(collision)
	
	if owner.GroundCollision:
		if owner.BallJump:
			ChangeState("Land")
		else:
			owner.BallJump = false
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


func CheckGroundCollision(collision: CharCollision) -> bool:
	if collision.CollisionType == CharCollision.NONE:
		if owner.GroundCollision:
			print("Left Ground")
		return false
	elif collision.CollisionType == CharCollision.FLOOR:
		return true
	elif collision.CollisionType == CharCollision.WALL:
		if owner.is_on_wall_only():
			owner.CollisionCast.target_position = -collision.CollisionNormal
			if CheckCollisionCast():
				owner.CreateCollisionIndicator(owner.CollisionCast.get_collision_point(), owner.CollisionCast.get_collision_normal())
				return true
			else:
				return false
		else:
			return false
	else: #ceiling hit
		if Vector3.UP.dot(owner.up_direction) > 0.75:
			#hit ceiling
			
			return false
		else:
			#falling down
			owner.CollisionCast.target_position = owner.up_direction
			owner.CollisionCast.force_raycast_update()
			if CheckCollisionCast():
				owner.UpdateUpDir(owner.CollisionCast.get_collision_normal(), -1.0)
			
			return true
	
	return true
