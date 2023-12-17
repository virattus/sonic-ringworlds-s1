class_name ThirdPersonCamera
extends Node3D


@export var Target : CharacterTarget
@export var CameraDistance := 5.0
@export var ForwardSensitivity := 1.0
@export var ReverseSensitivity := 1.0


var Rot := Vector2(0.0, -0.25)


const VERTICAL_CLAMP = 1.5

const CAM_Y_LERP_ROT_SPEED = 4.0
const CAM_Y_REGULAR_ROT = -0.4
const CAM_Y_OBSTACLE_AVOID_ROT = -0.65

@onready var Cam = $SpringArm3D/CameraTriggerBody/Camera3D
@onready var SpringArm = $SpringArm3D
@onready var StateMachine = $StateMachine


func _ready():
	DebugMenu.AddMonitor(self, "global_position")
	DebugMenu.AddMonitor(self, "Rot")
	SpringArm.spring_length = CameraDistance


func GetCamera() -> Camera3D:
	return Cam


func GetCameraPosition() -> Vector3:
	return Cam.global_position


func GetCameraBasis() -> Basis:
	return Cam.get_camera_transform().basis


func GetCameraDistance() -> float:
	return Cam.position.z


func Activate() -> void:
	Cam.current = true
	Globals.CurrentCamera = Cam


func UpdateRotation() -> void:
	transform.basis = Basis()
	Rot.y = clamp(Rot.y, -VERTICAL_CLAMP, VERTICAL_CLAMP)
	
	rotate_object_local(Vector3(0, 1, 0), Rot.x)
	rotate_object_local(Vector3(1, 0, 0), Rot.y)
	#SpringArm.rotate_y(Rot.x - SpringArm.rotation.y)
	#SpringArm.rotate_x(Rot.y - SpringArm.rotation.x)
	
	while Rot.x < 0.0:
		Rot.x += TAU
	while Rot.x > TAU:
		Rot.x -= TAU


func ChangeState(newState: String, msg := {}) -> void:
	StateMachine.ChangeState(newState, msg)
