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
	
	var collision: SonicCollision = owner.GetCollision()
	
	if collision.CollisionType == SonicCollision.NONE:
		ChangeState("Fall")
		return
	
	if Input.is_action_just_pressed("Jump"):
		ChangeState("Jump")
		return
	
	var inputVel = owner.GetInputVector(owner.up_direction)
	
	if inputVel.length() > 0.0:
		ChangeState("Walk")
		return
