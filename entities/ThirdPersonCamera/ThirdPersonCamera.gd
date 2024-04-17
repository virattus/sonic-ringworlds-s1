class_name ThirdPersonCamera
extends Node3D

@export var Active := true
@export var RightAnalogue := true
@export var char : CharacterBody3D
@export var Focus: Node3D

var CurrentBasis := Basis.IDENTITY

var up_axis := Vector3.UP

var CamRotation := 0.0


@onready var cam = $SpringArm3D/Camera3D

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
	
	position = char.position
	
	#var alignment = basis_aligned_y(transform.basis, char.up_direction)
	#transform.basis = transform.basis.slerp(alignment, 0.2)
	#CharRotation()
	if RightAnalogue:
		cam_input()
	else:
		shoulder_cam_input(delta)
	
	
	$SpringArm3D.spring_length = CAM_ARM_MIN_LENGTH + ((clamp(char.Speed, CAM_ARM_SPEED_MIN, CAM_ARM_SPEED_MAX) - CAM_ARM_SPEED_MIN) * CAM_ARM_SPEED_SCALE)
	
	$SpringArm3D/Camera3D.look_at(Focus.global_position)
	CurrentBasis = transform.basis


func GetCamera() -> Camera3D:
	return cam


func GetCameraBasis() -> Basis:
	return cam.global_transform.basis


func shoulder_cam_input(_delta: float) -> void:
	var cam_input = Input.get_axis("Shoulder_Cam_Left", "Shoulder_Cam_Right") * (1.0 if Globals.InvertCamera else -1.0)
	
	if cam_input > 0.0 or cam_input < -0.0:
		CamRotation = clamp(CamRotation + (cam_input * CAM_ROT_ACCEL_SPEED * _delta), -CAM_MAX_ROT_SPEED, CAM_MAX_ROT_SPEED)
	else:
		CamRotation = lerp(CamRotation, 0.0, CAM_REDUCTION_SPEED * _delta)
	
	transform.basis = transform.basis.rotated(up_axis, CamRotation * 0.1)
	


func cam_input() -> void:
	var CAM_INPUT = Input.get_vector("Camera_Right", "Camera_Left", "Camera_Down", "Camera_Up")
	
	transform.basis = transform.basis.rotated(up_axis, CAM_INPUT.x * (0.1 if Globals.InvertCamera else -0.1))
	
	$SpringArm3D.rotation.x -= CAM_INPUT.y * 0.1
	$SpringArm3D.rotation.x = clamp($SpringArm3D.rotation.x, deg_to_rad(-80), deg_to_rad(60))


func CharRotation() -> void:
	var speed = char.Speed
	if speed > 1.0:
		var dotRight = char.velocity.normalized().dot(-cam.global_transform.basis.x)
		transform.basis = transform.basis.rotated(up_axis, dotRight * speed * 0.001)
	
	 


func basis_aligned_y(basis_to_align: Basis, vector_to_align_with: Vector3) -> Basis:
	basis_to_align.y = vector_to_align_with
	basis_to_align.x = -basis_to_align.z.cross(basis_to_align.y)
	basis_to_align = basis_to_align.orthonormalized()
	return basis_to_align
