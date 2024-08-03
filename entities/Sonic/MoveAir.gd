extends BasicState


func ApplyDrag(velocity: Vector3, delta: float) -> Vector3:
	velocity.x = lerp(velocity.x, 0.0, delta)
	velocity.z = lerp(velocity.z, 0.0, delta)
	
	return velocity


func HandleCollisions() -> bool:
	var collision : SonicCollision = owner.GetCollision()
	
	if collision.CollisionType != SonicCollision.NONE:
		owner.GroundCollision = true
		var type = "Normal"
		var normal = collision.CollisionNormal
		if collision.CollisionType == SonicCollision.WALL:
			if Vector3.UP.dot(owner.up_direction) < 0.5:
				if owner.up_direction.dot(collision.CollisionNormal) < 0.5:
					type = "Wipeout"
		elif collision.CollisionType == SonicCollision.CEILING:
			if Vector3.UP.dot(owner.up_direction) > 0.0:
				#Bonked head
				owner.velocity.y = 0.0
				return false
			else:
				#Landed upside down, need to get a floor normal
				type = "Wipeout"
				owner.GroundCast.force_raycast_update()
				normal = owner.GroundCast.get_collision_normal()
				
		ChangeState("Land", {
			"Type": type,
			"Normal": normal,
		})
		return false
	
	return true
