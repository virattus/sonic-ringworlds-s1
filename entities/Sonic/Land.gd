extends BasicState




func Enter(_msg := {}) -> void:
	owner.SndLand.play()
	owner.up_direction = owner.FloorNormal
	owner.CharMesh.AlignToY(owner.FloorNormal)

	if owner.Speed > owner.PARAMETERS.MOVE_MIN_SPEED:
		ChangeState("Move")
	else:
		ChangeState("Idle")


func Exit() -> void:
	pass


func Update(_delta: float) -> void:
	pass
