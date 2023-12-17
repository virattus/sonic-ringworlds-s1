extends BasicState



const CAMERA_ROT_SPEED = 5.0

func Enter(_msg := {}) -> void:
	pass
	

func Exit() -> void:
	pass
	

func Update(_delta: float) -> void:
	if Input.is_action_just_pressed("ResetCamera"):
		ChangeState("Reset", {
			"ResetAngle": Vector2(owner.TargetChar.CharMesh.rotation.y, owner.CAM_Y_REGULAR_ROT)
		})
		return
	
	var CameraInput = Input.get_vector("Camera_Left", "Camera_Right", "Camera_Up", "Camera_Down")
	
	owner.Rot.x += CameraInput.x * CAMERA_ROT_SPEED * _delta
	owner.Rot.y += CameraInput.y * CAMERA_ROT_SPEED * _delta
	
	owner.UpdateRotation()
	owner.global_position = owner.Target.global_position
