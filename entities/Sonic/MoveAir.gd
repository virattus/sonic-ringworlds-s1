extends BasicState


func ApplyDrag(velocity: Vector3, delta: float) -> Vector3:
	velocity.x = lerp(velocity.x, 0.0, delta)
	velocity.z = lerp(velocity.z, 0.0, delta)
	
	return velocity


func HandleCollisions() -> bool:
	var collision : SonicCollision = owner.GetCollision()
	
	if collision.CollisionType == SonicCollision.NONE:
		return false
	else:
		owner.CollisionCast.force_raycast_update()
		var CollisionNormal = owner.CollisionCast.get_collision_normal()
		if collision.CollisionType == SonicCollision.FLOOR:
			ChangeState("Land", {
				"Type": "Normal",
				"Normal": CollisionNormal,
			})
			return true
		elif collision.CollisionType == SonicCollision.WALL:
			if Vector3.UP.dot(owner.velocity.normalized()) < 0.0:
				#Heading downwards
				if Vector3.UP.dot(CollisionNormal) > 0.0:
					#Appropriate to land on this wall, which is actually a floor
					ChangeState("Land", {
						"Type": "Wipeout",
						"Normal": CollisionNormal,
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
					"Type": "Wipeout",
					"Normal": owner.GroundCast.get_collision_normal()
				})
				return true
	return false
