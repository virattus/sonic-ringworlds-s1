extends BasicState




func Enter(_msg := {}) -> void:
	pass


func Exit() -> void:
	pass


func Update(_delta: float) -> void:
	var MoveCollision = owner.move_and_slide()
	owner.apply_floor_snap()

	if !MoveCollision:
		ChangeState("Fall")
		return

	var MoveInput = Input.get_vector("Move_Left", "Move_Right", "Move_Forward", "Move_Backward")

	owner.velocity += Vector3(MoveInput.x, 0.0, MoveInput.y)

	if MoveInput.length() <= 0.0:
		ChangeState("Idle")
		return