extends "res://entities/Sonic/MoveGround.gd"


const BALL_UNCURL_MIN_UP_DOT = 0.85


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
	
	var collision: SonicCollision = owner.GetCollision()
	owner.GroundCollision = CheckGroundCollision(collision, _delta)
	
	if owner.GroundCollision:
		var minVel = WallRunMinVelocity()
		var planeVel = (owner.velocity - (owner.up_direction * owner.up_direction.dot(owner.velocity)))
		var planeSpeed = planeVel.length()
		
		if planeSpeed < minVel:
			print("Moving too slowly to stick to wall, Speed: %s ReqSpeed: %s" % [planeSpeed, minVel])
			owner.SetVelocity(planeVel + (owner.up_direction * owner.PARAMETERS.GROUND_NORMAL_HOP))
			owner.GroundCollision = false
		else:
			owner.apply_floor_snap()
			owner.SetVelocity(planeVel)
	
	var newVel = owner.velocity
	
	var inputVel = owner.GetInputVector(owner.up_direction)
	
	if inputVel.length() > 0.0:
		#var combinedVel = newVel + (inputVel * owner.PARAMETERS.WALK_SPEED_POWER * _delta)
		#newVel = (inputVel.normalized() * combinedVel.length())
		newVel += inputVel * owner.PARAMETERS.WALK_SPEED_POWER * _delta
	else:
		newVel = owner.ApplyDrag(newVel, _delta / 2.0)
		
	if !owner.GroundCollision:
		newVel = owner.ApplyGravity(newVel, _delta)
	
	var influence := CurveInfluence(_delta)
	
	if Vector3.UP.dot(owner.up_direction) > BALL_UNCURL_MIN_UP_DOT and influence.length() < 0.05 and newVel.length() < owner.PARAMETERS.BALL_MIN_SPEED:
		UncurlAndIdle()
		return
	
	newVel += influence
	
	owner.SetVelocity(newVel)


func CheckGroundCollision(collision: SonicCollision, delta: float) -> bool:	
	if collision.CollisionType == SonicCollision.NONE:
		if CheckFloorRaycast(delta):
			return true
		else:
			if owner.GroundCollision:
				print("Left Ground")
			return false
	elif collision.CollisionType == SonicCollision.FLOOR:
		if CheckFloorRaycast(delta):
			return true
		else:
			#Too large of an angle to transition
			owner.SetVelocity(owner.velocity + (owner.up_direction * owner.PARAMETERS.GROUND_NORMAL_HOP))
			return false
	elif collision.CollisionType == SonicCollision.WALL:
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


func ApplyAirDrag(vel: Vector3, delta: float) -> Vector3:
	vel.x = lerp(vel.x, 0.0, delta)
	vel.z = lerp(vel.z, 0.0, delta)
	
	return vel


func AttackHit(_Target: Hurtbox) -> void:
	print("Ball: Hit enemy")
	owner.DashModeCharge += 0.2
	if !owner.GroundCollision:
		owner.velocity.y = owner.PARAMETERS.ATTACK_BOUNCE_POW


func UncurlAndIdle() -> void:
	owner.CharMesh.look_at(owner.global_position + owner.velocity)
	owner.CharMesh.AlignToY(owner.up_direction)
	ChangeState("Idle")
	
