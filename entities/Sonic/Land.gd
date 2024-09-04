extends "res://entities/Sonic/MoveGround.gd"


const LAND_CROUCH_MAX_SPEED = 0.5


func Enter(_msg := {}) -> void:
	if _msg.has("Normal"):
		owner.UpdateUpDir(_msg["Normal"], -1.0)
		owner.CharMesh.AlignToY(owner.up_direction)
	
	owner.CreateCollisionIndicator(owner.CollisionCast.get_collision_point(), owner.CollisionCast.get_collision_normal())
	
	if _msg.has("Type"):
		if _msg["Type"] == "Wipeout":
			ChangeState("Wipeout")
			return
	
	if _msg.has("Flicker"):
		owner.Flicker = true
		owner.TimerFlicker.wait_time = _msg["Flicker"]
		owner.TimerFlicker.start()
	
	owner.GroundCollision = true
	owner.StickToFloor = true
	owner.HasJumped = false
	owner.SndLand.play()
	owner.CharMesh.AlignToY(owner.up_direction)
	
	print("Landed")
	
	owner.CreateSmoke()
	
	var newInput = owner.GetInputVector(owner.up_direction)

	if newInput.length() > 0.0 or owner.up_direction.dot(owner.velocity) > LAND_CROUCH_MAX_SPEED:
		if newInput.normalized().dot(owner.CharMesh.GetForwardVector()) < 0.0:
			ChangeState("Skid")
			return
		else:
			ChangeState("Move")
			return
	

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
	if !HandleMovementAndCollisions(_delta):
		ChangeState("Fall")
		return
	
	
	if !owner.AnimTree.get("parameters/OSLand/active"):
		ChangeState("Idle")
		return


func LandAnim() -> void:
	pass
