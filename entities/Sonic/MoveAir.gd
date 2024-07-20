extends BasicState


const GRAVITY = 9.8

const AIR_DRAG_MODIFIER = 0.5


func ApplyGravity(velocity: Vector3, delta: float) -> Vector3:
	velocity.y -= GRAVITY * delta
	
	return velocity


func ApplyDrag(velocity: Vector3, delta: float) -> Vector3:
	velocity.x = lerp(velocity.x, 0.0, AIR_DRAG_MODIFIER * delta)
	velocity.z = lerp(velocity.z, 0.0, AIR_DRAG_MODIFIER * delta)
	
	return velocity
