extends BasicState


var CanStick := true
var UpDir := Vector3.ZERO

func Enter(_msg := {}) -> void:
	if _msg.has("UpDir"):
		UpDir = _msg["UpDir"]
	else:
		UpDir = owner.up_direction
	
	if _msg.has("CanStick"):
		CanStick = _msg["CanStick"]
	else:
		CanStick = true
	
	owner.AnimTree.set("parameters/Movement/blend_amount", 1.0)
	owner.AnimTree.set("parameters/Air/blend_amount", 0.0)


func Exit() -> void:
	pass


func Update(_delta: float) -> void:
	var vel = owner.velocity
	vel += owner.Controller.InputVelocity
	vel.y -= owner.PARAMETERS.GRAVITY * _delta * (0.5 if Input.is_action_pressed("Jump") else 1.0)
	
	owner.CharGroundCast.target_position = (owner.velocity.normalized()) * owner.CharGroundCastLength
	
	owner.Move(vel)
	#owner.CharMesh.look_at(owner.global_position + owner.velocity)
	
	var groundDot = owner.FloorNormal.dot(Vector3.UP)
	
	if owner.is_on_ceiling():
		ChangeState("Wipeout", {
			"UpDir": UpDir,
		})
		return
	
	if owner.is_on_wall_only():
		var wallDot = owner.velocity.normalized().dot(owner.get_wall_normal())
		print("wall dot: ", wallDot)
		if wallDot > 0.0:
			ChangeState("Wipeout", {
				"UpDir": UpDir,
			})
			return
	
	if owner.is_on_floor():
		
		
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
	
	
	#if owner.CheckFixedGroundCast():
	#	print("fixed found ground")
