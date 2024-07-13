extends BasicState




func Enter(_msg := {}) -> void:
	owner.velocity = Vector3.ZERO


func Exit() -> void:
	pass


func Update(_delta: float) -> void:
	var MoveCollision = owner.move_and_slide()
	
	if Input.is_action_just_pressed("Jump"):
		owner.velocity += owner.up_direction * owner.JUMP_POWER
		ChangeState("Fall")
		return
	
	if MoveCollision:
		owner.apply_floor_snap()
	else:
		owner.GroundCollision = false
		ChangeState("Fall")
		return
	
	
	var MoveInput = Input.get_vector("Move_Left", "Move_Right", "Move_Forward", "Move_Backward")
	
	if MoveInput.length() > 0.0:
		ChangeState("Move")
		return
