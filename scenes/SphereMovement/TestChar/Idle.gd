extends BasicState



func Enter(_msg := {}) -> void:
	owner.GroundCollision = true
	owner.velocity = Vector3.ZERO


func Exit() -> void:
	pass


func Update(_delta: float) -> void:
	var IsColliding = owner.move_and_slide()
	owner.apply_floor_snap()
	
	
	if Input.is_action_just_pressed("Jump"):
		ChangeState("Jump")
		return

	if !IsColliding:
		ChangeState("Fall")
		return

	if owner.GetInputVector().length() > 0.0:
		ChangeState("Run")
		return
