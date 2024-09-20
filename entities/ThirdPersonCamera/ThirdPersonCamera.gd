extends GameCamera



@export var Active := true
@export var Char : Character
@export var Focus: Node3D

var CurrentBasis := Basis.IDENTITY

var up_axis := Vector3.UP

var CamRotation := Vector2.ZERO



const CAM_ROT_ACCEL_SPEED = 1.0
const CAM_MAX_ROT_SPEED = 1.0
const CAM_REDUCTION_SPEED = 15.0

const CAM_ARM_MIN_LENGTH = 3.0
const CAM_ARM_SPEED_MIN = 6.0
const CAM_ARM_SPEED_MAX = 28.0
const CAM_ARM_SPEED_SCALE = 0.05



func _ready() -> void:
	DebugMenu.AddMonitor(self, "global_position")
	DebugMenu.AddMonitor(self, "CamRotation")


func _process(delta: float) -> void:
	if !Active:
		return
	
	up_axis = self.transform.basis.y
	
	position = Char.position + Vector3(0, 1, 0)
	
	#var alignment = basis_aligned_y(transform.basis, char.up_direction)
	#transform.basis = transform.basis.slerp(alignment, 0.2)
	#CharRotation()
	cam_input(delta)
	
	
	$SpringArm3D.spring_length = CAM_ARM_MIN_LENGTH + ((clamp(Char.Speed, CAM_ARM_SPEED_MIN, CAM_ARM_SPEED_MAX) - CAM_ARM_SPEED_MIN) * CAM_ARM_SPEED_SCALE)
	
	$SpringArm3D/Camera3D.look_at(Focus.global_position)
	CurrentBasis = transform.basis


func cam_input(_delta: float) -> void:
	var camInput : Vector2 = Input.get_vector("Camera_Right", "Camera_Left", "Camera_Down", "Camera_Up") * Globals.CameraSensitivity
		
	if camInput.length() > 0.0:
		CamRotation.x = clamp(CamRotation.x + (camInput.x * CAM_ROT_ACCEL_SPEED * _delta), -CAM_MAX_ROT_SPEED, CAM_MAX_ROT_SPEED)
		CamRotation.y = clamp(CamRotation.y + (camInput.y * CAM_ROT_ACCEL_SPEED * _delta), -CAM_MAX_ROT_SPEED, CAM_MAX_ROT_SPEED)

	else:
		CamRotation = lerp(CamRotation, Vector2.ZERO, CAM_REDUCTION_SPEED * _delta)
	
	transform.basis = transform.basis.rotated(up_axis, CamRotation.x)
	
	$SpringArm3D.rotation.x -= CamRotation.y
	$SpringArm3D.rotation.x = clamp($SpringArm3D.rotation.x, deg_to_rad(-80), deg_to_rad(60))


func CharRotation() -> void:
	var speed = Char.Speed
	if speed > 1.0:
		var dotRight = Char.velocity.normalized().dot(-Cam.global_transform.basis.x)
		transform.basis = transform.basis.rotated(up_axis, dotRight * speed * 0.001)
	
	 


func basis_aligned_y(basis_to_align: Basis, vector_to_align_with: Vector3) -> Basis:
	basis_to_align.y = vector_to_align_with
	basis_to_align.x = -basis_to_align.z.cross(basis_to_align.y)
	basis_to_align = basis_to_align.orthonormalized()
	return basis_to_align
