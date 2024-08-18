extends BasicState


const AIR_WIPEOUT_MIN = 0.75


func ApplyDrag(velocity: Vector3, delta: float) -> Vector3:
	velocity.x = lerp(velocity.x, 0.0, delta)
	velocity.z = lerp(velocity.z, 0.0, delta)
	
	return velocity


func CheckGroundCollision(collision: SonicCollision) -> bool:
	if collision.CollisionType == SonicCollision.NONE:
		return false
	else:
		if collision.CollisionType == SonicCollision.FLOOR:
			owner.CollisionCast.force_raycast_update()
			if owner.CollisionCast.is_colliding():
				ChangeState("Land", {
					"Type": "Normal",
					"Normal": owner.CollisionCast.get_collision_normal(),
				})
				return true
			else:
				ChangeState("Land", {
					"Type": "Normal",
					"Normal": owner.up_direction,
				})
				return true
		elif collision.CollisionType == SonicCollision.WALL:
			if owner.velocity.y < 0.0:
				#Heading downwards
				owner.CollisionCast.target_position = owner.to_local(owner.get_last_slide_collision().get_position()).normalized()
				owner.CollisionCast.force_raycast_update()
				if owner.CollisionCast.is_colliding():
					var collisionNormal = owner.CollisionCast.get_collision_normal()
					if Vector3.UP.dot(collisionNormal) > AIR_WIPEOUT_MIN:
						#Appropriate to land on this wall, which is actually a floor
						if collisionNormal.dot(owner.velocity.normalized()) > -0.25:
							print("Wall wipeout: %s" % (collisionNormal.dot(owner.velocity.normalized())))
							ChangeState("Land", {
								"Type": "Wipeout",
								"Normal": owner.CollisionCast.get_collision_normal(),
							})
							return true
				else:
					#Failed to hit the wall that we collided with, figure out what to do
					return false
				#reset collisioncast
				owner.CollisionCast.target_position = -owner.up_direction * owner.COLLISION_CAST_LENGTH
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
