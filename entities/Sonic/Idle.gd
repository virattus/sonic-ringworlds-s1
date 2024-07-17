extends BasicState



func Enter(_msg := {}) -> void:
	owner.AnimTree.set("parameters/Movement/blend_amount", 0.0)
	owner.AnimTree.set("parameters/Ground/blend_amount", 0.0)
	owner.AnimTree.set("parameters/GroundSecondary/blend_amount", -1.0)
	owner.AnimTree.set("parameters/Idle/blend_amount", 0.0)
	
	owner.SetVelocity(Vector3.ZERO)
	

func Exit() -> void:
	pass


func Update(_delta: float) -> void:
	owner.Move()
	owner.apply_floor_snap()
	
	owner.CharMesh.AlignToY(owner.up_direction)
	owner.up_direction = owner.up_direction.slerp(owner.FloorNormal.normalized(), _delta * owner.UP_VEC_LERP_RATE).normalized()
	
	owner.GroundCollision = false
	if owner.is_on_floor():
		owner.FloorNormal = owner.get_floor_normal()
		owner.GroundCollision = true
	else:
		owner.CharGroundCast.force_raycast_update()
		if owner.CharGroundCast.is_colliding():
			owner.FloorNormal = owner.CharGroundCast.get_collision_normal()
			owner.GroundCollision = true
	
	
	owner.CharGroundCast.target_position = -(owner.FloorNormal.normalized()) * owner.CharGroundCastLength
	owner.up_direction = owner.FloorNormal
	
	if !owner.GroundCollision:
		ChangeState("Air", {
			"SubState": "Fall",
		})
		return
	
	if owner.up_direction.dot(Vector3.UP) < owner.PARAMETERS.IDLE_MIN_GROUND_ANGLE:
		ChangeState("Air", {
			"SubState": "Fall",
		})
		return
	
	if Input.is_action_just_pressed("Jump"):
		ChangeState("Air", {
			"SubState": "Jump",
		})
		return
	
	if Input.is_action_just_pressed("Attack"):
		ChangeState("SquatCharge")
		return
	
	if owner.GetInputVector().length() > 0.0:
		ChangeState("Move", {
			"SubState": "Walk",
		})
		return
