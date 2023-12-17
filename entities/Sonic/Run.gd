extends BasicState


var Speed := 0.0


func Enter(_msg := {}) -> void:
	if _msg.has("CurrentSpeed"):
		Speed = _msg["CurrentSpeed"]
	else:
		Speed = owner.RUN_MAX_SPEED
	
	owner.AnimTree.set("parameters/Ground/blend_amount", 1.0)
	owner.AnimTree.set("parameters/Movement/blend_amount", 0.0)


func Exit() -> void:
	owner.AnimTree.set("parameters/Run-Time/scale", 1.0)
	


func Update(_delta: float) -> void:
	if !owner.GroundCollision:
		ChangeState("Fall")
		return
	
	if owner.Controller.InputJump:
		ChangeState("Jump")
		return
	
	var vel = owner.velocity.normalized()
	Speed = owner.Speed
	
	
	#As the character speeds up, we want the controller input's "weight" to reduce
	vel = ((vel * Speed) + owner.Controller.InputVelocity).normalized() 
	if owner.Controller.InputVelocity.length() >= 0.8:
		Speed += owner.MOVE_SPEED_ADD_MODIFIER * _delta
		if Speed > owner.RUN_MAX_SPEED:
			ChangeState("Sprint", {
				"CurrentSpeed": Speed,
				})
			return
	else:
		Speed -= owner.MOVE_SPEED_ADD_MODIFIER * _delta
		if Speed <= owner.WALK_MAX_SPEED:
			ChangeState("Walk")
			return
		elif Speed <= 0.0:
			ChangeState("Idle")
			return
	
	owner.AnimTree.set("parameters/Run-Time/scale", Speed * 0.5)
	
	owner.Move(vel * Speed)
	owner.CharMesh.LerpMeshOrientation(owner.velocity, _delta)
