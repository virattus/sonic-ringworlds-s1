extends BasicState


const MIN_RUN_VEL = 1.0
const MIN_LAND_STOP_Y_VEL = 15.0


func Enter(_msg := {}) -> void:
	if _msg.has("FloorNormal"):
		pass
	
	owner.GroundCollision = true
	owner.SndLand.play()
	owner.up_direction = owner.FloorNormal
	owner.CharMesh.AlignToY(owner.FloorNormal)

	owner.CameraFocus.position = Vector3(0, 0.5, 0)

	if owner.velocity.length() > 0.0:
		if owner.velocity.y <= MIN_LAND_STOP_Y_VEL:
			#if IsInputSkidding():
			#	ChangeState("Skid")
			#else:
			if owner.Speed >= owner.PARAMETERS.WALK_MAX_SPEED:
				ChangeState("Run")
			else:
				ChangeState("Walk")

	#Activate landing anim
	owner.AnimTree.set("parameters/Movement/blend_amount", 0.0)
	owner.AnimTree.set("parameters/Ground/blend_amount", 0.0)
	owner.AnimTree.set("parameters/GroundSecondary/blend_amount", -1.0)
	owner.AnimTree.set("parameters/Idle/blend_amount", 0.0)
	owner.AnimTree.set("parameters/OSLand/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
	
	owner.velocity = Vector3.ZERO


func Exit() -> void:
	owner.AnimTree.set("parameters/OSLand/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_ABORT)


func Update(_delta: float) -> void:
	owner.Move()
	
	if !owner.AnimTree.get("parameters/OSLand/active"):
		ChangeState("Idle")
		return
