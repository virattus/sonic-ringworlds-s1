extends BasicState




func Enter(_msg := {}) -> void:
	owner.GroundCollision = true
	owner.SndLand.play()
	owner.up_direction = owner.FloorNormal
	owner.CharMesh.AlignToY(owner.FloorNormal)

	owner.CameraFocus.position = Vector3(0, 0.5, 0)

	if owner.velocity.length() > 0.0:
		if IsInputSkidding():
			ChangeState("Skid")
		else:
			ChangeState("Move")
	else:
		ChangeState("Idle")


func Exit() -> void:
	pass


func Update(_delta: float) -> void:
	pass



func IsInputSkidding() -> bool:
	if owner.Controller.InputVelocity.length() > owner.PARAMETERS.SKID_INPUT_MIN:
		var InputDir = owner.velocity.normalized().dot(owner.Controller.InputVelocity.normalized())
		if InputDir < owner.PARAMETERS.SKID_ANGLE_MIN:
			print("Land: Skid ratio: %s" % InputDir)
			return true
		
	return false
