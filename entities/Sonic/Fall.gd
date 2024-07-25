extends "res://entities/Sonic/MoveAir.gd"




func Enter(_msg := {}) -> void:
	owner.AnimTree.set("parameters/Movement/blend_amount", 1.0)
	owner.AnimTree.set("parameters/Air/blend_amount", 0.0)


func Exit() -> void:
	pass


func Update(_delta: float) -> void:
	owner.Move()
	
	#TODO angles
	owner.GroundCollision = owner.CollisionDetection(0.0, 0.0)
	
	if owner.GroundCollision:
		ChangeState("Land")
		return
	
	var newVel = owner.velocity
	
	newVel += owner.GetInputVector()
	
	newVel = ApplyGravity(newVel, _delta)
	newVel = ApplyDrag(newVel, _delta)
	
	owner.SetVelocity(newVel)
	
	if Input.is_action_just_pressed("Jump"):
		if Input.is_action_just_pressed("Attack"):
			ChangeSubState("Pose")
			return
		else:
			ChangeSubState("Airdash")
			return
		
	if Input.is_action_just_pressed("Attack"):
		if owner.DashMode:
			ChangeSubState("SpinKick", {
				"JumpVel": get_parent().AirVel,
			})
			return
		else:
			ChangeState("Ball", {
				"VerticalVelocity": get_parent().AirVel.y,
			})
			return
