extends BasicState


func ApplyGravity(_delta: float) -> void:
	owner.velocity += Vector3.DOWN * (owner.GRAVITY * _delta)


func ApplyDrag(_delta: float) -> void:
	owner.velocity.x = lerp(owner.velocity.x, 0.0, owner.AIR_DRAG_MODIFIER * _delta)
	owner.velocity.z = lerp(owner.velocity.z, 0.0, owner.AIR_DRAG_MODIFIER * _delta)
