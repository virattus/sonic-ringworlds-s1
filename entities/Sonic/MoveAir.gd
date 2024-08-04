extends BasicState


const AIR_WIPEOUT_MIN = 0.75


func ApplyDrag(velocity: Vector3, delta: float) -> Vector3:
	velocity.x = lerp(velocity.x, 0.0, delta)
	velocity.z = lerp(velocity.z, 0.0, delta)
	
	return velocity


func HandleCollisions() -> bool:
	var collision : SonicCollision = owner.GetCollision()
	
	if collision.CollisionType == SonicCollision.NONE:
		return false
	else:
		if collision.CollisionType == SonicCollision.FLOOR:
			owner.CollisionCast.force_raycast_update()
			ChangeState("Land", {
				"Type": "Normal",
				"Normal": owner.CollisionCast.get_collision_normal(),
			})
			return true
		elif collision.CollisionType == SonicCollision.WALL:
			if owner.velocity.y < 0.0:
				#Heading downwards
				owner.CollisionCast.target_position = owner.global_position + collision.CollisionNormal
				owner.CollisionCast.force_raycast_update()
				print(owner.CollisionCast.get_collision_normal())
				if Vector3.UP.dot(owner.CollisionCast.get_collision_normal()) > AIR_WIPEOUT_MIN:
					#Appropriate to land on this wall, which is actually a floor
					ChangeState("Land", {
						"Type": "Wipeout",
						"Normal": owner.CollisionCast.get_collision_normal(),
					})
					return true
		elif collision.CollisionType == SonicCollision.CEILING:
			if Vector3.UP.dot(owner.velocity.normalized()) > 0.0:
				#travelling up, we bonked our head
				owner.velocity.y = 0.0
				return false
			else:
				#Landed upside down
				owner.GroundCast.force_raycast_update() #Need a ground normal
				ChangeState("Land", {
					"Type": "Normal",
					"Normal": owner.GroundCast.get_collision_normal()
				})
				return true
	return false
