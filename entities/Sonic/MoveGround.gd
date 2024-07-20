extends BasicState


const GROUND_DRAG_MODIFIER = 1.0

func ApplyDrag(velocity: Vector3, delta: float) -> Vector3:
	velocity = lerp(velocity, Vector3.ZERO, GROUND_DRAG_MODIFIER * delta)
	
	return velocity
