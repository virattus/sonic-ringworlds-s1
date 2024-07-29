extends BasicState


const WALLRUN_ANGLE_SPEED_RATIO = 5.0


func ApplyDrag(velocity: Vector3, delta: float) -> Vector3:
	velocity = lerp(velocity, Vector3.ZERO, delta)
	
	return velocity


func HandleCollisions(delta: float) -> bool:
	var collision: SonicCollision = owner.GetCollision()
	
	if collision.CollisionType == SonicCollision.NONE:
		return false
	elif (collision.CollisionType == SonicCollision.FLOOR) or (collision.CollisionType == SonicCollision.WALL):
		owner.UpdateUpDir(collision.CollisionNormal, delta)
		if collision.CollisionType == SonicCollision.FLOOR:
			if owner.up_direction.dot(collision.CollisionNormal) < owner.PARAMETERS.GROUND_NORMAL_TRANSITION_MIN:
				#Too large of an angle to transition
				owner.SetVelocity(owner.velocity + (owner.up_direction * owner.PARAMETERS.GROUND_NORMAL_HOP))
				ChangeState("Fall")
				return false
	return true



func WallRunMinVelocity() -> bool:
	var floorAngle = (-Vector3.UP.dot(owner.up_direction) + 1.0)
	
	var reqSpeed = floorAngle * WALLRUN_ANGLE_SPEED_RATIO
	
	if owner.Speed < reqSpeed:
		print("Moving too slowly to stick to wall, Speed: %s ReqSpeed: %s" % [owner.Speed, reqSpeed])
		owner.SetVelocity(owner.velocity + (owner.up_direction * owner.PARAMETERS.GROUND_NORMAL_HOP))
		ChangeState("Fall")
		return false
	
	return true
