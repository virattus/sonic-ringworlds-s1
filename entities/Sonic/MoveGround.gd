extends BasicState


const WALLRUN_ANGLE_SPEED_RATIO = 7.0

const WALLRUN_CURVE_INFLUENCE_MOD = 1.25


func CurveInfluence(delta: float) -> Vector3:
	#var influence = (Vector3.DOWN * owner.PARAMETERS.GRAVITY * delta) * (owner.up_direction * Vector3(1, 0, 1)).length()
	var influence = (Vector3.DOWN * owner.CurrentGravity * delta) * (owner.up_direction * Vector3(1, 0, 1)).length()
	return influence * WALLRUN_CURVE_INFLUENCE_MOD


func HandleMovementAndCollisions(delta: float) -> bool:
	owner.Move()
	
	var collision : SonicCollision = owner.GetCollision()
	if CheckGroundCollision(collision, delta):
		if collision.CollisionType == SonicCollision.FLOOR and CheckWallCollision():
			#print("Colliding with wall and floor")
			if owner.get_wall_normal().dot(Vector3.UP) > 0.8:
				ChangeState("Land", {
					"Normal": Vector3.UP,
					"Type": "Normal",
				})
				return false
		
		var minVel = WallRunMinVelocity()
		#print(minVel)
		if owner.Speed < minVel:
			print("Moving too slowly to stick to wall, Speed: %s ReqSpeed: %s" % [owner.Speed, minVel])
			owner.SetVelocity(owner.velocity + (owner.up_direction * owner.PARAMETERS.GROUND_NORMAL_HOP))
			owner.GroundCollision = false
			owner.StickToFloor = false
			return false
		
		owner.apply_floor_snap()
		owner.GroundCollision = true
	else:
		owner.GroundCollision = false
		if owner.RunOnWater:
			if owner.IsOnWaterSurface():
				owner.UpdateUpDir(owner.WaterSurfaceCast.get_collision_normal(), -1.0)
				return true
		return false 
	
	return true


func CheckCollisionCast() -> bool:
	owner.CollisionCast.force_raycast_update()
	if owner.CollisionCast.is_colliding():
		return true
	else:
		return false


func CheckGroundTransition() -> bool:
	if owner.up_direction.dot(owner.CollisionCast.get_collision_normal()) > owner.PARAMETERS.GROUND_NORMAL_TRANSITION_MIN:
		return true
	else:
		return false


func CheckFloorRaycast(delta: float) -> bool:
	if CheckCollisionCast():
		if CheckGroundTransition():
			if !owner.GroundCollision:
				owner.CreateCollisionIndicator(owner.CollisionCast.get_collision_point(), owner.CollisionCast.get_collision_normal())
			owner.UpdateUpDir(owner.CollisionCast.get_collision_normal(), delta)
			return true
		else:
			#ground angle too steep
			print("Ground Angle too steep")
			return false
	else:
		#definitely not on ground
		return false


func CheckGroundCollision(collision: SonicCollision, delta: float) -> bool:
	if collision.CollisionType == SonicCollision.NONE:
		return CheckFloorRaycast(delta)
	elif collision.CollisionType == SonicCollision.FLOOR:
		if CheckFloorRaycast(delta):
			return true
		else:
			print("Left Ground")
			owner.SetVelocity(owner.velocity + (owner.up_direction * owner.PARAMETERS.GROUND_NORMAL_HOP))
			return false
	elif collision.CollisionType == SonicCollision.WALL:
		if owner.is_on_wall_only():
			if CheckFloorRaycast(delta):
				return true
			else:
				owner.CollisionCast.target_position = owner.to_local(owner.get_last_slide_collision().get_position()).normalized()
				owner.CollisionCast.force_raycast_update()
				owner.CollisionCast.target_position = -owner.up_direction * owner.COLLISION_CAST_LENGTH
				if owner.CollisionCast.is_colliding():
					ChangeState("Teetering", {
						
					})
					return true
			return false
		else:
			return true
	else:
		if owner.up_direction.y > 0.0:
			#Bonked head
			return false
		else:
			#Landed upside down
			return true
		
	return true


func CheckWallCollision() -> bool:
	return owner.is_on_wall()


func WallRunMinVelocity() -> float:
	var floorAngle = clamp(Vector3.DOWN.dot(owner.up_direction), 0.0, 1.0)
	
	var reqSpeed = (floorAngle) * WALLRUN_ANGLE_SPEED_RATIO
	
	return reqSpeed
