extends CharacterBody3D


@export var Cam : Node3D

var GroundCollision := false
var Speed := 0.0

@onready var UpIndicator = $UpIndicator
@onready var InputIndicator = $InputIndicator

const GRAVITY = 9.8

const GROUND_SLERP_RATE = 10.0
const GROUND_TRANSITION_MIN = 0.75
const GROUND_WALLRUN_MIN_ANGLE = 0.5
const GROUND_WALLRUN_MIN_SPEED = 3.0

const AIR_UP_VEC_SLERP = 1.0
const AIR_DRAG_MODIFIER = 0.5

const JUMP_POWER = 10.0

const COLLISION_INDICATOR = preload("res://entities/Collision/Collision.tscn")


####
#LOOK INTO  PhysicsDirectSpace3D.get_rest_info(parameters: PhysicsShapeQueryParameters3D)
#for getting the surface normal



func _ready() -> void:
	DebugMenu.AddMonitor(self, "velocity")
	DebugMenu.AddMonitor(self, "Speed")
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
	
	Speed = velocity.length()

	var newVelocity = GetInputVector(up_direction)
	if !GroundCollision:
		newVelocity = GetInputVector(Vector3.UP)
	
	InputIndicator.global_position = global_position + newVelocity.normalized()
	
	
	
	velocity += newVelocity * delta * 20.0
	
	if GroundCollision:
		velocity = lerp(velocity, Vector3.ZERO, delta)
	
	#Air Drag
	if !GroundCollision:
		velocity.x = lerp(velocity.x, 0.0, delta)
		velocity.z = lerp(velocity.z, 0.0, delta)
	

	UpdateCollision(delta)

	if Input.is_action_just_pressed("Jump"):
		if GroundCollision:
			print("Jumping, left floor")
		else:
			print("Jumping, Air")
		velocity = (velocity * (InputIndicator.global_position - global_position).normalized()) + (up_direction * 10.0)
		GroundCollision = false
	
	#too slow to continue wallrun
	if GroundCollision and velocity.length() < GROUND_WALLRUN_MIN_SPEED and up_direction.dot(Vector3.UP) < GROUND_WALLRUN_MIN_ANGLE:
		print("Falling off wall, too slow to wallrun")
		GroundCollision = false
		velocity += up_direction * 0.1


func AlignToY(_transform: Transform3D, newY: Vector3) -> Transform3D:
	_transform.basis.y = newY
	_transform.basis.x = -_transform.basis.z.cross(newY)
	_transform.basis = _transform.basis.orthonormalized()
	return _transform


func GetInputVector(up_dir: Vector3) -> Vector3:
	var playerInput = Input.get_vector("Move_Left", "Move_Right", "Move_Forward", "Move_Backward")
	
	#var CameraForward = (Cam.global_transform.basis.z * Vector3(1, 0, 1)).normalized()
	#var CameraRight = (Cam.global_transform.basis.x * Vector3(1, 0, 1)).normalized()
	
	var CameraForward = Cam.global_transform.basis.z
	var CameraRight = Cam.global_transform.basis.x
	
	var newInput = (CameraForward * playerInput.y) + (CameraRight * playerInput.x)
	
	var newVelocity = (Quaternion(Vector3.UP, up_dir).normalized()) * newInput
	
	#newVelocity.y = 0.0
	
	#print(newVelocity)

	return newVelocity





func UpdateCollision(delta: float) -> void:
	#hit floor
	if is_on_floor():
		var floorNormal = get_floor_normal()
		if up_direction.dot(floorNormal) > GROUND_TRANSITION_MIN:
			if !GroundCollision:
				print("Hit Floor")
				GroundCollision = true
			up_direction = up_direction.slerp(get_floor_normal(), GROUND_SLERP_RATE * delta)
		else: #Too far of an angle to transition
			if GroundCollision:
				print("Left floor, too great an angle")
				GroundCollision = false
				#velocity += up_direction * 0.05
	#hit wall
	elif is_on_wall():
		var wallNormal = get_wall_normal()
		#"wall" is actually floor
		if Vector3.UP.dot(wallNormal) > 0.5:
			#if falling down
			if Vector3.UP.dot(velocity.normalized()) < 0.0:
				print("Landed Sideways")
				up_direction = wallNormal
				GroundCollision = true
		else:
			if is_on_wall_only():
				ApplyGravity(delta)
			else:
				print("Hit Wall")
	#hit ceiling
	elif is_on_ceiling():
		if Vector3.UP.dot(up_direction) < 0.0:
			print("Landed upside down")
			up_direction = get_last_slide_collision().get_normal()
			GroundCollision = true
		else:
			print("Hit Ceiling")
			velocity.y = 0.0
	#Not on anything
	else:
		ApplyGravity(delta)


func ApplyGravity(delta: float) -> void:
	if GroundCollision:
		print("Left Floor")
		GroundCollision = false
	
	velocity -= Vector3.UP * (9.8 * delta)



func CreateCollIndicator() -> void:
	$RayCast3D.target_position = -up_direction
	$RayCast3D.force_raycast_update()
	if $RayCast3D.is_colliding():
		var collInd = COLLISION_INDICATOR.instantiate()
		get_parent().add_child(collInd)
		collInd.SetToRaycast($RayCast3D)
