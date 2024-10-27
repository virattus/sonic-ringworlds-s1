extends "res://entities/Player/MoveGround.gd"



const BALL_GROUND_FRICTION = 0.0234375


func Enter(_msg := {}) -> void:
	owner.SonicModel.visible = false
	owner.SonicBall.visible = true
	owner.ActivateHitbox(true)
	owner.DamageThreshold = owner.Parameters.DAMAGE_THRESHOLD_BALL
	
	if _msg.has("PlayChargeSound") and _msg["PlayChargeSound"]:
		owner.SndSpinCharge.play()


func Exit() -> void:
	#owner.CharMesh.LookAt(owner.velocity.normalized())
	owner.BallJump = false
	owner.SonicModel.visible = true
	owner.SonicBall.visible = false
	owner.ActivateHitbox(false)
	#owner.DamageThreshold = owner.Parameters.DAMAGE_THRESHOLD_NORMAL


func Update(_delta: float) -> void:
	owner.Move()
	
	var collision: CharCollision = owner.GetCollision()
	owner.GroundCollision = CheckGroundCollision(collision, _delta)
	
	if owner.GroundCollision:
		if collision.CollisionType == CharCollision.FLOOR and CheckWallCollision():
			print("Ball: Colliding with wall and floor")
			if owner.get_wall_normal().dot(Vector3.UP) > 0.8:
				owner.up_direction = owner.get_wall_normal()
		
		var minVel = WallRunMinVelocity()
		var planeVel = (owner.velocity - (owner.up_direction * owner.up_direction.dot(owner.velocity)))
		var planeSpeed = planeVel.length()
		
		if planeSpeed < minVel:
			print("Moving too slowly to stick to wall, Speed: %s ReqSpeed: %s" % [planeSpeed, minVel])
			owner.SetVelocity(planeVel + (owner.up_direction * owner.Parameters.GROUND_NORMAL_HOP))
			ChangeState("BallAir")
			return
		else:
			owner.apply_floor_snap()
			owner.SetVelocity(planeVel)
	else:
		owner.BallJump = true
		ChangeState("BallAir", {
			
		})
		return
	
	if Input.is_action_just_pressed("Jump"):
		owner.SndJump.play()
		owner.velocity += owner.up_direction * owner.Parameters.JUMP_POWER
		ChangeState("BallAir")
		return
	
	var newVel = owner.velocity

	var inputVel = owner.GetInputVector(owner.up_direction)
	
	if inputVel.length() > 0.0:
		#var combinedVel = newVel + (inputVel * owner.PARAMETERS.WALK_SPEED_POWER * _delta)
		#newVel = (inputVel.normalized() * combinedVel.length())
		if newVel.normalized().dot(inputVel.normalized()) < -0.25:
			newVel = newVel.lerp(Vector3.ZERO, _delta)
		else:
			var tempSpeed = newVel.length()
			newVel += inputVel * owner.Parameters.WALK_SPEED_POWER * _delta
			newVel = newVel.normalized() * tempSpeed
	else:
		newVel = owner.ApplyDrag(newVel, _delta / 2.0)
		#newVel *= 1.0 - BALL_GROUND_FRICTION
	
	var influence := CurveInfluence(_delta)
	
	if Vector3.UP.dot(owner.up_direction) > owner.Parameters.BALL_UNCURL_MIN_UP_DOT and influence.length() < 0.05 and newVel.length() < owner.Parameters.BALL_MIN_SPEED:
		UncurlAndIdle()
		return
	
	newVel += influence
	
	owner.CharMesh.LerpMeshOrientation(newVel.normalized(), _delta)
	owner.SetVelocity(newVel)


func CheckGroundCollision(collision: CharCollision, delta: float) -> bool:	
	if collision.CollisionType == CharCollision.NONE:
		if CheckFloorRaycast(delta):
			return true
		else:
			if owner.GroundCollision:
				print("Left Ground")
			return false
	elif collision.CollisionType == CharCollision.FLOOR:
		if CheckFloorRaycast(delta):
			return true
		else:
			#Too large of an angle to transition
			owner.SetVelocity(owner.velocity + (owner.up_direction * owner.Parameters.GROUND_NORMAL_HOP))
			return false
	elif collision.CollisionType == CharCollision.WALL:
		if owner.is_on_wall_only():
			owner.CollisionCast.target_position = -collision.CollisionNormal
			if CheckCollisionCast():
				owner.CreateCollisionIndicator(owner.CollisionCast.get_collision_point(), owner.CollisionCast.get_collision_normal())
				owner.UpdateUpDir(owner.CollisionCast.get_collision_normal(), delta)
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
				owner.UpdateUpDir(owner.CollisionCast.get_collision_normal(), delta)
			
			return true
	
	return true


func AttackHit(_Target: Hurtbox) -> void:
	print("Ball: Hit enemy")
	if !owner.GroundCollision:
		owner.velocity.y = owner.Parameters.ATTACK_BOUNCE_POW


func UncurlAndIdle() -> void:
	owner.CharMesh.look_at(owner.global_position + owner.velocity)
	owner.CharMesh.AlignToY(owner.up_direction)
	owner.DamageThreshold = owner.Parameters.DAMAGE_THRESHOLD_NORMAL
	owner.SndSpinCharge.stop()
	ChangeState("Idle")
