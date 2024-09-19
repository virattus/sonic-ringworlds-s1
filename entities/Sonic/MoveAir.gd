extends BasicState


var OldVel := Vector3.ZERO

const AIR_WIPEOUT_MIN = 0.75


func ApplyDrag(velocity: Vector3, delta: float) -> Vector3:
	var delMod = 1.0
	if owner.IsUnderwater:
		delMod = 2.0
	
	velocity.x = lerp(velocity.x, 0.0, delta * delMod)
	velocity.z = lerp(velocity.z, 0.0, delta * delMod)
	
	return velocity



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


func CheckGroundCollision(collision: SonicCollision) -> bool:
	if collision.CollisionType == SonicCollision.NONE:
		if owner.StickToFloor:
			if CheckFloorRaycast(1.0):
				ChangeState("Land", {
					"Type": "Normal",
					"Normal": owner.CollisionCast.get_collision_normal(),
					"Vel": OldVel,
				})
				return true
			return false
	elif collision.CollisionType == SonicCollision.FLOOR:
		if CheckFloorRaycast(1.0):
			ChangeState("Land", {
				"Type": "Normal",
				"Normal": owner.CollisionCast.get_collision_normal(),
				"Vel": OldVel,
			})
			return true
		else:
			ChangeState("Teetering", {
				
			})
			return true
	elif collision.CollisionType == SonicCollision.WALL:
		#This only fires if we're hitting just a wall, so we need to make certain that we're 
		#actually colliding with a wall specifically, and not just rubbing on one as we fall down
		owner.CollisionCast.target_position = owner.to_local(owner.get_last_slide_collision().get_position()).normalized()
		owner.CollisionCast.force_raycast_update()
		owner.CollisionCast.target_position = -owner.up_direction * owner.COLLISION_CAST_LENGTH
		if owner.CollisionCast.is_colliding():
			#found wall
			var collisionNormal = owner.CollisionCast.get_collision_normal()
			if Vector3.UP.dot(collisionNormal) > 0.75:
				#Wall is floor
				ChangeState("Land", {
					"Type": "Normal",
					"Normal": collisionNormal,
				})
				return true
			else:
				return false
		else:
			#Failed to find wall
			return false
	elif collision.CollisionType == SonicCollision.CEILING:
		if Vector3.UP.dot(owner.up_direction) < 0.0:
			#Landed upside down
			owner.GroundCast.force_raycast_update() #Need a ground normal
			ChangeState("Land", {
				"Type": "Normal",
				"Normal": owner.GroundCast.get_collision_normal()
			})
			return true
		else:
			#travelling up, bonked our head
			return false
	#this should never fire
	return false


func AttackHit(_Target: Hurtbox) -> void:
	print("%s: Hit enemy" % self.name)
	owner.velocity.y = owner.PARAMETERS.ATTACK_BOUNCE_POW
