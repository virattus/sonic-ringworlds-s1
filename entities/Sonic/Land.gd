extends BasicState


const LAND_MIN_SPEED = 0.5


func Enter(_msg := {}) -> void:
	if _msg.has("Normal"):
		owner.CreateCollisionIndicator(owner.CollisionCast.get_collision_point(), owner.CollisionCast.get_collision_normal())
		owner.UpdateUpDir(_msg["Normal"], 1.0)
		owner.CharMesh.AlignToY(owner.up_direction)
	
	
	if _msg.has("Type"):
		if _msg["Type"] == "Wipeout":
			ChangeState("Wipeout")
			return
	
	owner.GroundCollision = true
	owner.HasJumped = false
	owner.SndLand.play()
	owner.CharMesh.AlignToY(owner.up_direction)
	
	print("Landed")

	if owner.Speed > LAND_MIN_SPEED:
		ChangeState("Walk")
		return
		
		#if owner.Speed > owner.PARAMETERS.WALK_MAX_SPEED:
		#	ChangeState("Run")
		#	return
		#else:
		#	ChangeState("Walk")
		#	return
	

	owner.SetVelocity(Vector3.ZERO)
	owner.CameraFocus.position = Vector3(0, 0.5, 0)
	
	
	#Activate landing anim
	owner.AnimTree.set("parameters/Movement/blend_amount", 0.0)
	owner.AnimTree.set("parameters/Ground/blend_amount", 0.0)
	owner.AnimTree.set("parameters/GroundSecondary/blend_amount", -1.0)
	owner.AnimTree.set("parameters/Idle/blend_amount", 0.0)
	owner.AnimTree.set("parameters/OSLand/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)


func Exit() -> void:
	owner.AnimTree.set("parameters/OSLand/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_ABORT)


func Update(_delta: float) -> void:
	owner.Move()
	
	if !owner.AnimTree.get("parameters/OSLand/active"):
		ChangeState("Idle")
		return


func LandAnim() -> void:
	pass
