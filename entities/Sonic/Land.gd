extends BasicState




func Enter(_msg := {}) -> void:
	var UpDir := Vector3.UP
	if _msg.has("UpDir"):
		UpDir = _msg["UpDir"]
	
	owner.SndLand.play()
	
	var landDot = UpDir.dot(owner.FloorNormal)
	print("LandDot: %s" % landDot)
	owner.CharMesh.AlignToY(owner.FloorNormal)
	owner.up_direction = owner.FloorNormal
	
	if landDot > owner.PARAMETERS.LAND_ANGLE_MIN:
		if owner.Speed > owner.PARAMETERS.MOVE_MIN_SPEED:
			ChangeState("Move")
		else:
			ChangeState("Idle")
	else:
		ChangeState("Wipeout")


func Exit() -> void:
	pass


func Update(_delta: float) -> void:
	pass
