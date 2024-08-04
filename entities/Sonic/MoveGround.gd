extends BasicState


const WALLRUN_ANGLE_SPEED_RATIO = 5.0


func ApplyDrag(velocity: Vector3, delta: float) -> Vector3:
	velocity = lerp(velocity, Vector3.ZERO, delta)
	
	return velocity


func HandleMovementAndCollisions(delta: float) -> bool:
	owner.Move()
	
	if !HandleCollisions(delta):
		return false
	
	if !WallRunMinVelocity():
		return false
	
	return true


func HandleCollisions(delta: float) -> bool:
	var collision: SonicCollision = owner.GetCollision()
	
	if collision.CollisionType == SonicCollision.NONE:
		if owner.GroundCollision:
			print("Left Ground")
			owner.CreateCollisionIndicator(owner.CollisionCast.get_collision_point(), owner.CollisionCast.get_collision_normal())
		owner.CollisionCast.force_raycast_update()
		if owner.CollisionCast.is_colliding():
			var collisionNormal = owner.CollisionCast.get_collision_normal()
			if owner.up_direction.dot(collisionNormal) > owner.PARAMETERS.GROUND_NORMAL_TRANSITION_MIN:
				owner.CreateCollisionIndicator(owner.CollisionCast.get_collision_point(), collisionNormal)
				owner.UpdateUpDir(collisionNormal, delta)
				owner.apply_floor_snap()
				return true #We ARE colliding with the floor, it turns out
		return false
	elif (collision.CollisionType == SonicCollision.FLOOR):
		owner.CollisionCast.force_raycast_update()
		if owner.CollisionCast.is_colliding():
			var collisionNormal = owner.CollisionCast.get_collision_normal()
			if owner.up_direction.dot(collisionNormal) > owner.PARAMETERS.GROUND_NORMAL_TRANSITION_MIN:
				owner.UpdateUpDir(collisionNormal, delta)
				owner.apply_floor_snap()
			else:
				#Too large of an angle to transition
				owner.SetVelocity(owner.velocity + (owner.up_direction * owner.PARAMETERS.GROUND_NORMAL_HOP))
				return false
		else:
			return false
	elif (collision.CollisionType == SonicCollision.WALL):
		
		if owner.is_on_wall_only():
			return false
		else:
			pass
		
	return true



func WallRunMinVelocity() -> bool:
	var floorAngle = Vector3.DOWN.dot(owner.up_direction.normalized())
	
	var reqSpeed = (floorAngle) * WALLRUN_ANGLE_SPEED_RATIO
	
	if owner.Speed < reqSpeed:
		print("Moving too slowly to stick to wall, Speed: %s ReqSpeed: %s" % [owner.Speed, reqSpeed])
		owner.SetVelocity(owner.velocity + (owner.up_direction * owner.PARAMETERS.GROUND_NORMAL_HOP))
		ChangeState("Fall")
		return false
	
	return true



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
