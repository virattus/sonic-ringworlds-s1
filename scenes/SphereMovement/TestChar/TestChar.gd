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
		
	var CameraForward = (Cam.global_transform.basis.z * Vector3(1, 1, 1)).normalized()
	var CameraRight = (Cam.global_transform.basis.x * Vector3(1, 1, 1)).normalized()
	
	
	#var newVelocity = ((global_transform.basis.z * playerInput.y) + (global_transform.basis.x * playerInput.x))
	
	var newInput = (CameraForward * playerInput.y) + (CameraRight * playerInput.x)
	
	var newVelocity = (Quaternion(Vector3.UP, up_direction).normalized()) * newInput
	
	#newVelocity.y = 0.0
	
	#print(newVelocity)
	
	velocity += newVelocity * delta * 20.0
	
	velocity.x = lerp(velocity.x, 0.0, delta)
	velocity.z = lerp(velocity.z, 0.0, delta)
	

	if is_on_floor():
		if !GroundCollision:
			GroundCollision = true
			print("Hit Ground")
	
		up_direction = up_direction.slerp(get_floor_normal(), GROUND_SLERP_RATE * delta)
		
		
#		$RayCast3D.force_raycast_update()
#		if $RayCast3D.is_colliding():
#			var collInd = COLLISION_INDICATOR.instantiate()
#			get_parent().add_child(collInd)
#			collInd.SetToRaycast($RayCast3D)
#			
#			var groundNormal = $RayCast3D.get_collision_normal()
#			var yAligned = AlignToY(global_transform, groundNormal)
#			global_transform = global_transform.interpolate_with(yAligned, speed * delta)
#			up_direction = groundNormal
			#print("Aligned with ground")
	
	elif is_on_wall_only():
		if !GroundCollision:
			GroundCollision = true
			print("Hit Wall")
			
		up_direction = up_direction.slerp(get_wall_normal(), GROUND_SLERP_RATE * delta)
	
	elif is_on_ceiling_only():
		if up_direction.y < 0.0:
			#Upside down
			if !GroundCollision:
				GroundCollision = true
				print("Hit Floor Upside Down")
			up_direction = Vector3.UP
			pass
		else:
			print("Hit Ceiling")
			velocity.y = 0.0
			pass
		
	else:
		if GroundCollision:
			GroundCollision = false
			print("left ground")
		
		velocity -= Vector3.UP * (10.0 * delta)
		up_direction = up_direction.slerp(Vector3.UP, AIR_UP_VEC_SLERP * delta)


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


func CreateCollIndicator() -> void:
	$RayCast3D.target_position = -up_direction
	$RayCast3D.force_raycast_update()
	if $RayCast3D.is_colliding():
		var collInd = COLLISION_INDICATOR.instantiate()
		get_parent().add_child(collInd)
		collInd.SetToRaycast($RayCast3D)
