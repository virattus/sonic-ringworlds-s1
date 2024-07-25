extends "res://entities/Sonic/MoveAir.gd"




func Enter(_msg := {}) -> void:
	owner.AnimTree.set("parameters/Air/blend_amount", -1.0)
	
	owner.SndJump.play()
	
	owner.CharMesh.AlignToY(owner.FloorNormal)


func Exit() -> void:
	pass


func Update(_delta: float) -> void:
	owner.Move()
	
	owner.GroundCollision = owner.CollisionDetection(0, 0)
	
	if Input.is_action_just_pressed("Jump"):
		if Input.is_action_just_pressed("Attack"):
			ChangeState("Pose")
			return
		else:
			ChangeState("Airdash")
			return
	
	if Input.is_action_just_pressed("Attack"):
		if owner.DashMode:
			ChangeState("SpinKick", {
			})
			return
		else:
			ChangeState("Ball", {
				"VerticalVelocity": get_parent().AirVel.y,
			})
			return

	if owner.velocity.y <= 0.0:
		ChangeState("Fall", {
		})
		return
