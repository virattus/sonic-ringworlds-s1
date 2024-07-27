extends BasicState



func ApplyDrag(velocity: Vector3, delta: float) -> Vector3:
	velocity = lerp(velocity, Vector3.ZERO, delta)
	
	return velocity
