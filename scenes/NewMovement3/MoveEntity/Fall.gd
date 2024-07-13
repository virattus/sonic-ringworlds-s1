extends BasicState




func Enter(_msg := {}) -> void:
	pass


func Exit() -> void:
	pass


func Update(_delta: float) -> void:
	var MoveCollision = owner.move_and_slide()
	
	if MoveCollision:
		owner.GroundCollision = true
		ChangeState("Move")
		return
	
	owner.velocity.y -= owner.GRAVITY * _delta
	
	var MoveInput = Input.get_vector("Move_Left", "Move_Right", "Move_Forward", "Move_Backward")
