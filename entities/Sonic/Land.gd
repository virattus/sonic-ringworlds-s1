extends BasicState




func Enter(_msg := {}) -> void:
	owner.SndLand.play()
	owner.up_direction = owner.FloorNormal
	owner.CharMesh.AlignToY(owner.FloorNormal)

	if owner.Speed > owner.PARAMETERS.MOVE_MIN_SPEED:
		if owner.Controller.InputVelocity.length() > 0.0:
			if owner.Controller.InputVelocity.dot(owner.velocity.normalized()) < 0.75:
				ChangeState("Skid")
		ChangeState("Move")
	else:
		ChangeState("Idle")


func Exit() -> void:
	pass


func Update(_delta: float) -> void:
	pass
