extends BasicState


const WALLRUN_ANGLE_SPEED_RATIO = 4.0

const WALLRUN_CURVE_INFLUENCE_MOD = 2.0


func ApplyDrag(velocity: Vector3, delta: float) -> Vector3:
	velocity = lerp(velocity, Vector3.ZERO, delta)
	
	return velocity


func CurveInfluence(delta: float) -> Vector3:
	var influence = (Vector3.DOWN * owner.PARAMETERS.GRAVITY * delta) * (owner.up_direction * Vector3(1, 0, 1)).length()
	return influence * WALLRUN_CURVE_INFLUENCE_MOD


func HandleMovementAndCollisions(delta: float) -> bool:
	owner.Move()
	
	if !HandleCollisions(delta):
		return false 
	
	var minVel = WallRunMinVelocity()
	#print(minVel)
	if owner.Speed < minVel:
		print("Moving too slowly to stick to wall, Speed: %s ReqSpeed: %s" % [owner.Speed, minVel])
		owner.SetVelocity(owner.velocity + (owner.up_direction * owner.PARAMETERS.GROUND_NORMAL_HOP))
		ChangeState("Fall")
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


func CheckFloorCollision(delta: float) -> bool:
	if CheckCollisionCast():
		if CheckGroundTransition():
			if !owner.GroundCollision:
				owner.CreateCollisionIndicator(owner.CollisionCast.get_collision_point(), owner.CollisionCast.get_collision_normal())
			owner.UpdateUpDir(owner.CollisionCast.get_collision_normal(), delta)
			owner.apply_floor_snap()
			return true
		else:
			#ground angle too steep
			print("Ground Angle too steep")
			return false
	else:
		#definitely not on ground
		return false


func HandleCollisions(delta: float) -> bool:
	var collision: SonicCollision = owner.GetCollision()
	
	if collision.CollisionType == SonicCollision.NONE:
		return CheckFloorCollision(delta)
	elif collision.CollisionType == SonicCollision.FLOOR:
		if CheckFloorCollision(delta):
			return true
		else:
			owner.SetVelocity(owner.velocity + (owner.up_direction * owner.PARAMETERS.GROUND_NORMAL_HOP))
			return false
	elif (collision.CollisionType == SonicCollision.WALL):
		
		if owner.is_on_wall_only():
			return false
		else:
			pass
		
	return true


func WallRunMinVelocity() -> float:
	var floorAngle = Vector3.DOWN.dot(owner.up_direction.normalized())
	
	var reqSpeed = (floorAngle) * WALLRUN_ANGLE_SPEED_RATIO
	
	
	return reqSpeed



func UpdateMoveAnimations() -> void:
	owner.CharMesh.AlignToY(owner.up_direction)
	
	if owner.Speed > owner.PARAMETERS.RUN_MAX_SPEED:
		owner.AnimTree.set("parameters/Run/blend_amount", 1.0)
		owner.AnimTree.set("parameters/TSSprint/scale", owner.Speed * owner.PARAMETERS.SPRINT_ANIM_SPEED_MOD)
	elif owner.Speed > owner.PARAMETERS.WALK_MAX_SPEED:
		owner.AnimTree.set("parameters/Run/blend_amount", 0.0)
		owner.AnimTree.set("parameters/TSRun/scale", owner.Speed * owner.PARAMETERS.RUN_ANIM_SPEED_MOD)
	else:
		owner.AnimTree.set("parameters/Run/blend_amount", -1.0)
		owner.AnimTree.set("parameters/TSWalk/scale", owner.Speed * owner.PARAMETERS.WALK_ANIM_SPEED_MOD)
