class_name ThirdPersonCamera
extends Node3D

@export var Active := true
@export var RightAnalogue := true
@export var char : CharacterBody3D

var CurrentBasis := Basis.IDENTITY

var up_axis := Vector3.UP


@onready var cam = $SpringArm3D/Camera3D


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
		shoulder_cam_input()
	CurrentBasis = transform.basis


func GetCameraBasis() -> Basis:
	return cam.global_transform.basis


func shoulder_cam_input() -> void:
	var cam_input = Input.get_axis("Shoulder_Cam_Left", "Shoulder_Cam_Right")
	
	transform.basis = transform.basis.rotated(up_axis, -cam_input * 0.1)
	


func cam_input() -> void:
	var CAM_INPUT = Input.get_vector("Camera_Right", "Camera_Left", "Camera_Down", "Camera_Up")
	
	transform.basis = transform.basis.rotated(up_axis, -CAM_INPUT.x * 0.1)
	
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
