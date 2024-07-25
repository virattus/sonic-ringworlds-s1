extends BasicState



const COLLISION_INDICATOR = preload("res://entities/Collision/Collision.tscn")


func Enter(_msg := {}) -> void:
	if _msg.has("FloorNormal"):
		pass
	
	owner.GroundCollision = true
	owner.SndLand.play()
	owner.up_direction = owner.FloorNormal
	owner.CharMesh.AlignToY(owner.FloorNormal)

	owner.CameraFocus.position = Vector3(0, 0.5, 0)

	if owner.velocity.length() > 0.0:
		#if IsInputSkidding():
		#	ChangeState("Skid")
		#else:
		if owner.Speed >= owner.PARAMETERS.WALK_MAX_SPEED:
			ChangeState("Run")
		else:
			ChangeState("Walk")
	else:
		ChangeState("Idle")


func Exit() -> void:
	pass


func Update(_delta: float) -> void:
	pass
