extends BasicState


var UpDir := Vector3.ZERO

func Enter(_msg := {}) -> void:
	if _msg.has("UpDir"):
		UpDir = _msg["UpDir"]
	else:
		UpDir = owner.up_direction
	
	owner.AnimTree.set("parameters/Movement/blend_amount", 1.0)
	owner.AnimTree.set("parameters/Air/blend_amount", 0.0)


func Exit() -> void:
	pass


func Update(_delta: float) -> void:
	if owner.CheckGroundCollision():
		ChangeState("Land", {
			"UpDir": UpDir,
		})
		return
	#elif owner.CheckFixedGroundCast():
	#	print("didn't find ground, but raycast did")
	#	ChangeState("Land", {
	#		"UpDir": UpDir,
	#	})
	#	return
	
	if Input.is_action_just_pressed("Jump"):
		ChangeState("Airdash")
		return
	
	
	var vel = owner.velocity
	#vel += owner.Controller.InputVelocity
	vel.y -= owner.PARAMETERS.GRAVITY * _delta * (0.5 if Input.is_action_pressed("Jump") else 1.0)
	
	owner.CharGroundCast.target_position = (owner.velocity.normalized())
	
	owner.Move(vel)
	#owner.CharMesh.look_at(owner.global_position + owner.velocity)
	
	if owner.CheckFixedGroundCast():
		print("fixed found ground")
