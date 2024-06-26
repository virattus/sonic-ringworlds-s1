extends CharacterBody3D


@export var Cam : Camera3D

var GroundCollision := false


const COLLISION_INDICATOR = preload("res://entities/Collision/Collision.tscn")


func _physics_process(delta: float) -> void:
	move_and_slide()
	apply_floor_snap()
	var speed = velocity.length()
	
	velocity += Vector3.DOWN * (10.0 * delta)

	if is_on_floor():
		if !GroundCollision:
			GroundCollision = true
			print("Hit Ground")
	
		var playerInput = Input.get_vector("Move_Left", "Move_Right", "Move_Forward", "Move_Backward")
		
		var CameraForward = (Cam.basis.z * Vector3(1, 0, 1)).normalized()
		var CameraRight = (Cam.basis.x * Vector3(1, 0, 1)).normalized()
		
		velocity += ((global_transform.basis.z * playerInput.y) + (global_transform.basis.x * playerInput.x))
	
		if Input.is_action_just_pressed("Jump"):
			velocity += up_direction * 10.0
		
		if $RayCast3D.is_colliding():
			#var collInd = COLLISION_INDICATOR.instantiate()
			#get_parent().add_child(collInd)
			#collInd.SetToRaycast($RayCast3D)
			
			var groundNormal = $RayCast3D.get_collision_normal()
			var yAligned = AlignToY(global_transform, groundNormal)
			global_transform = global_transform.interpolate_with(yAligned, speed * delta)
			up_direction = groundNormal
			#print("Aligned with ground")
	
	else:
		if GroundCollision:
			GroundCollision = false
			print("left ground")
		



func AlignToY(_transform: Transform3D, newY: Vector3) -> Transform3D:
	_transform.basis.y = newY
	_transform.basis.x = -_transform.basis.z.cross(newY)
	_transform.basis = _transform.basis.orthonormalized()
	return _transform
