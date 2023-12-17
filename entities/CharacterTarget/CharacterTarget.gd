class_name CharacterTarget
extends Node3D



@export var Active := true
@export var TargetChar : Character
@export var TargetCamera : ThirdPersonCamera
@export var OffsetRange := Vector2(1.0, 1.0)


var Velocity : Vector3 = Vector3(0.0, 0.0, 0.0)
var IsWallColliding := false
var WallCollision := Vector3.ZERO
var ResetAngle := 0.0

@onready var Offset : Vector3
@onready var BasePosition = position

@onready var RaycastToCam = $RayCastToCamera

const MIN_DOT_TO_FORWARD = 0.7
const TARGET_MOVEMENT_SPEED = 1.5
const HORIZ_LERP_SPEED = 0.3
const HORIZ_LERP_RETURN_SPEED = 0.2


func _ready():
	DebugMenu.AddMonitor(self, "position")
	DebugMenu.AddMonitor(self, "Velocity")
	DebugMenu.AddMonitor(self, "IsWallColliding")
	DebugMenu.AddMonitor(self, "WallCollision")
	DebugMenu.AddMonitor(self, "ResetAngle")
	


func _process(delta: float) -> void:
	if !Active:
		return
	
	HandleWallCollision()
	HandleHorizSlide(delta)
	
	Velocity = TargetChar.velocity
	ResetAngle = TargetChar.CharMesh.rotation.y #Figure out a better way


func HandleWallCollision() -> void:
	var camHorizPos = (TargetCamera.GetCameraPosition() * Vector3(1, 0, 1)) + Vector3(0, global_position.y, 0)
	RaycastToCam.target_position = (camHorizPos - global_position).normalized() * 5.0 # replace with camera springarm distance
	RaycastToCam.force_raycast_update()
	IsWallColliding = RaycastToCam.is_colliding()
	if IsWallColliding:
		WallCollision = RaycastToCam.get_collision_point()
	else:
		WallCollision = Vector3.ZERO


func HandleHorizSlide(_delta: float) -> void:
	var charVel = TargetChar.velocity
	if charVel.length() > 1.0:
		charVel = charVel.normalized()
	
	var rightAngle = TargetCamera.GetCameraBasis().x.dot((charVel * Vector3(1, 0, 1)).normalized())
	#print(rightAngle)
	if abs(rightAngle) < MIN_DOT_TO_FORWARD:
		position = lerp(position, BasePosition, HORIZ_LERP_RETURN_SPEED * _delta)
		#bring back to centre
		pass
	else:
		#slide to left and right
		var RightCamVector = TargetCamera.GetCameraBasis().x.normalized() * Vector3(1, 0, 1) + BasePosition
		position = lerp(position, 
			(RightCamVector * Vector3(1, 0, 1)) * (OffsetRange.x * sign(rightAngle)) + BasePosition, 
			 HORIZ_LERP_SPEED * _delta * abs(rightAngle))
