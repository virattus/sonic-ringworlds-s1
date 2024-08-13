extends "res://entities/Sonic/MoveGround.gd"


const BALL_UNCURL_MIN_UP_DOT = 0.75


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
	
	owner.GroundCollision = HandleCollisions(_delta)
	
	
	if owner.GroundCollision and owner.Speed < owner.PARAMETERS.BALL_MIN_SPEED and Vector3.UP.dot(owner.up_direction) > BALL_UNCURL_MIN_UP_DOT:
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


func HandleCollisions(delta: float) -> bool:
	var collision: SonicCollision = owner.GetCollision()
	
	if collision.CollisionType == SonicCollision.NONE:
		if CheckFloorCollision(delta):
			return true
		else:
			if owner.GroundCollision:
				print("Left Ground")
			return false
	elif collision.CollisionType == SonicCollision.FLOOR:
		if CheckFloorCollision(delta):
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
			owner.CollisionCast.target_position = -owner.up_direction
			return CheckCollisionCast()
	
	return true


func AttackHit(_Target: Hurtbox) -> void:
	print("Ball: Hit enemy")
	owner.DashModeCharge += 0.2
	if !owner.GroundCollision:
		owner.velocity.y = owner.PARAMETERS.ATTACK_BOUNCE_POW


func UncurlAndIdle() -> void:
	owner.CharMesh.look_at(owner.global_position + owner.velocity)
	owner.CharMesh.AlignToY(owner.up_direction)
	ChangeState("Idle")
	
