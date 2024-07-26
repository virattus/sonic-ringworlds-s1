extends CharacterBody3D


@export var Cam : Node3D

var GroundCollision := false

@onready var UpIndicator = $UpIndicator

const GRAVITY = 9.8

const GROUND_SLERP_RATE = 8.0

const AIR_UP_VEC_SLERP = 1.0
const AIR_DRAG_MODIFIER = 0.5

const JUMP_POWER = 10.0

const COLLISION_INDICATOR = preload("res://entities/Collision/Collision.tscn")



func _ready() -> void:
	DebugMenu.AddMonitor(self, "velocity")
	DebugMenu.AddMonitor(self, "up_direction")
	DebugMenu.AddMonitor(self, "GroundCollision")


#func _physics_process(delta: float) -> void:
#	UpIndicator.position = up_direction


func _physics_process(delta: float) -> void:
	var IsColliding = move_and_slide()
	if GroundCollision:
		apply_floor_snap()
	
	UpIndicator.position = up_direction
	$RayCast3D.target_position = -up_direction
	
	CreateCollIndicator()
	
	var speed = velocity.length()


	var playerInput = Input.get_vector("Move_Left", "Move_Right", "Move_Forward", "Move_Backward")
		
	var CameraForward = Cam.global_transform.basis.z
	var CameraRight = Cam.global_transform.basis.x
	
	
	#var newVelocity = ((global_transform.basis.z * playerInput.y) + (global_transform.basis.x * playerInput.x))
	
	var newInput = (CameraForward * playerInput.y) + (CameraRight * playerInput.x)
	
	var newVelocity = (Quaternion(Vector3.UP, up_direction).normalized()) * newInput
	
	#newVelocity.y = 0.0
	
	#print(newVelocity)
	
	velocity += newVelocity * delta * 20.0
	
	velocity.x = lerp(velocity.x, 0.0, delta)
	velocity.z = lerp(velocity.z, 0.0, delta)
	

	UpdateCollision(delta)

	if Input.is_action_just_pressed("Jump"):
		velocity += up_direction * 10.0
		GroundCollision = false



func AlignToY(_transform: Transform3D, newY: Vector3) -> Transform3D:
	_transform.basis.y = newY
	_transform.basis.x = -_transform.basis.z.cross(newY)
	_transform.basis = _transform.basis.orthonormalized()
	return _transform


func GetInputVector() -> Vector3:
	var playerInput = Input.get_vector("Move_Left", "Move_Right", "Move_Forward", "Move_Backward")
	
	var CameraForward = (Cam.basis.z * Vector3(1, 0, 1)).normalized()
	var CameraRight = (Cam.basis.x * Vector3(1, 0, 1)).normalized()
	
	var newInput = (CameraForward * playerInput.y) + (CameraRight * playerInput.x)
	
	var newVelocity = (Quaternion(Vector3.UP, up_direction)) * newInput
	
	#newVelocity.y = 0.0
	
	#print(newVelocity)

	return newVelocity


func UpdateCollision(delta: float) -> void:
	if is_on_wall():
		var wallNormal = get_wall_normal()
		
		var wallDot = up_direction.dot(wallNormal)
		var vertDot = Vector3.UP.dot(wallNormal)
		
		#hit floor
		if wallDot > 0.75:
			if !GroundCollision:
				print("Hit Floor")
				GroundCollision = true
			
			up_direction = up_direction.slerp(wallNormal, GROUND_SLERP_RATE * delta)
		#hit wall
		elif wallDot > -0.25:
			if vertDot > 0.0:
				print("Landed Sideways")
				up_direction = wallNormal
				GroundCollision = true
			else:
				print("Hit Wall")
		#hit ceiling
		else:
			if vertDot > 0.0:
				print("Landed upside down")
				up_direction = wallNormal
				GroundCollision = true
			else:
				print("Hit Ceiling")
				velocity.y = 0.0
				
	
	#Not on anything
	else:
		if GroundCollision:
			print("Left Floor")
			GroundCollision = false
		
		velocity -= Vector3.UP * (10.0 * delta)
		#up_direction = up_direction.slerp(Vector3.UP, AIR_UP_VEC_SLERP * delta)


func CreateCollIndicator() -> void:
	$RayCast3D.target_position = -up_direction
	$RayCast3D.force_raycast_update()
	if $RayCast3D.is_colliding():
		var collInd = COLLISION_INDICATOR.instantiate()
		get_parent().add_child(collInd)
		collInd.SetToRaycast($RayCast3D)
