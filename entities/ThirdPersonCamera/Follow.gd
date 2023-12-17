extends BasicState


var LastFrameVel := Vector3.ZERO

const CAMERA_ROT_SPEED = 5.0
const ROTATION_MIN_VELOCITY = 0.1

func Enter(_msg := {}) -> void:
	LastFrameVel = Vector3.ZERO
	

func Exit() -> void:
	pass
	

func Update(_delta: float) -> void:
	
	if Input.is_action_just_pressed("ResetCamera"):
		ChangeState("Reset", {
			"ReturnState": "Follow",
			"ResetAngle": Vector2(owner.Target.ResetAngle, owner.Rot.y)
		})
		return
	
	var CameraInput = Input.get_vector("Camera_Left", "Camera_Right", "Camera_Up", "Camera_Down")
	
	owner.Rot.x += CameraInput.x * CAMERA_ROT_SPEED * _delta
	owner.Rot.y += CameraInput.y * CAMERA_ROT_SPEED * _delta


	#print(owner.Target.IsWallColliding)
	#print(owner.Target.WallCollision)
	var TargetPos = owner.CAM_Y_REGULAR_ROT
	if owner.Target.IsWallColliding:
		TargetPos = owner.CAM_Y_OBSTACLE_AVOID_ROT
		
	owner.Rot.y = lerp(owner.Rot.y, TargetPos, _delta * owner.CAM_Y_LERP_ROT_SPEED)
	

	if owner.Target.Velocity.length() > ROTATION_MIN_VELOCITY:
		#var targetRight = owner.TargetChar.CharMesh.global_transform.basis.x
		var targetRight = owner.Target.Velocity.rotated(Vector3(0, 1, 0), deg_to_rad(-90.0)) * Vector3(1, 0, 1)
		var camForward = owner.GetCameraBasis().z
		#var turnSpeed = snapped(((forward.dot(targetForward) * -1.0) + 1.0) * 0.5 * owner.Sensitivity, 0.0001)
		var turnSpeed = camForward.dot(targetRight.normalized())
		
		#var turnAngle = camForward.dot(owner.TargetChar.CharMesh.global_transform.basis.z)
		var turnAngle = camForward.dot(owner.Target.Velocity)
		
		#print("turnSpeed: " + str(turnSpeed))
		#print("turnAngle: " + str(turnAngle))
		
		owner.Rot.x += _delta * turnSpeed * -1.0 * (owner.ForwardSensitivity if turnAngle > 0.0 else owner.ReverseSensitivity)

	owner.UpdateRotation()
	owner.global_position = owner.Target.global_position
