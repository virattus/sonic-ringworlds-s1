extends BasicState



func Enter(_msg := {}) -> void:
	owner.AnimTree.set("parameters/Movement/blend_amount", -1.0)
	owner.AnimTree.set("parameters/Hang/blend_amount", 0.0)
	owner.AnimTree.set("parameters/OSHang/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
	
	owner.SetVelocity(Vector3.ZERO)
	
	owner.CollisionCast.target_position = Vector3.UP
	owner.UpdateUpDir(Vector3.UP, -1.0)
	owner.CharMesh.AlignToY(Vector3.UP)


func Exit() -> void:
	owner.AnimTree.set("parameters/OSHang/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_ABORT)
	
	owner.CollisionCast.target_position = -owner.up_direction


func Update(_delta: float) -> void:
	owner.Move()
	
	if !owner.CanHang or Input.is_action_just_released("Jump"):
		ChangeState("Fall")
		return
	

	var inputVel = owner.GetInputVector(Vector3.UP)
	
	inputVel *= owner.HangMovementAxis
	
	if inputVel.length() > 0.0:
		owner.CharMesh.LerpMeshOrientation(inputVel, _delta)
		owner.AnimTree.set("parameters/Hang/blend_amount", 1.0)
	else:
		owner.AnimTree.set("parameters/Hang/blend_amount", 0.0)


		
		
	
	owner.SetVelocity(inputVel)
	
