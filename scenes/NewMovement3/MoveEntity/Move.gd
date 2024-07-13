extends BasicState


const EPSILON = 0.001


func Enter(_msg := {}) -> void:
	pass


func Exit() -> void:
	pass


func Update(_delta: float) -> void:
	var MoveCollision = owner.move_and_slide()
	owner.apply_floor_snap()

	if Input.is_action_just_pressed("Jump"):
		owner.GroundCollision = false
		owner.velocity += owner.up_direction * owner.JUMP_POWER
		ChangeState("Fall")
		return

	if MoveCollision:
		var Coll: KinematicCollision3D = owner.get_last_slide_collision()
		owner.global_translate(Coll.get_travel())
		var delta := Coll.get_remainder()
		
		for i in range(Coll.get_collision_count()):
			var HitNormal = Coll.get_normal(i)
			var WallNormal = HitNormal
			
			var DotTest = PlaneProject(owner.velocity, HitNormal).dot(owner.up_direction)
			
			if owner.is_on_floor() or (HitNormal.dot(owner.up_direction) >= EPSILON and DotTest <= -EPSILON):
				WallNormal = PlaneProject(HitNormal, owner.up_direction).normalized()
			
			if owner.is_on_floor():
				pass
			

	if !MoveCollision:
		owner.GroundCollision = false
		ChangeState("Fall")
		return

	var MoveInput = Input.get_vector("Move_Left", "Move_Right", "Move_Forward", "Move_Backward")
	
	var Cam = get_viewport().get_camera_3d()
	
	var CamForward = (Cam.global_transform.basis.z * Vector3(1, 0, 1)).normalized()
	var CamRight = (Cam.global_transform.basis.x * Vector3(1, 0, 1)).normalized()
	
	var newInputVel = (MoveInput.y * CamForward) + (MoveInput.x * CamRight)
	
	owner.velocity += newInputVel

	if MoveInput.length() <= 0.0:
		ChangeState("Idle")
		return


func PlaneProject(vector: Vector3, plane: Vector3) -> Vector3:
	var dot = vector.dot(plane)
	return vector - plane * dot
