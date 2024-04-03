extends BasicState




func Enter(_msg := {}) -> void:
	owner.AnimTree.set("parameters/Movement/blend_amount", 0.0)
	owner.AnimTree.set("parameters/Ground/blend_amount", 1.0)
	owner.AnimTree.set("parameters/GroundSecondary/blend_amount", -1.0)
	owner.AnimTree.set("parameters/Run/blend_amount", 0.0)


func Exit() -> void:
	pass


func Update(_delta: float) -> void:
	owner.UpdateUpDir()
	owner.CheckCharGroundCast()
	owner.CharGroundCast.target_position = -(owner.FloorNormal.normalized())
	
	var vel = owner.velocity
	
	if owner.Controller.InputVelocity.length() > 0.0:
		vel += owner.Controller.InputVelocity
	else:
		vel = lerp(vel, Vector3.ZERO, _delta)
	
	owner.Move(vel)
	
	#owner.CharGroundCast.force_raycast_update()
	#if owner.CharGroundCast.is_colliding():
	#	owner.global_position = owner.CharGroundCast.get_collision_point() + (Vector3.UP * 0.5)
	
	owner.CharMesh.look_at(owner.global_position + owner.velocity.normalized())
	owner.CharMesh.AlignToY(owner.up_direction)
	#owner.CharMesh.LerpMeshOrientation(owner.Controller.InputVelocity.normalized(), _delta)
	
	owner.up_direction = owner.FloorNormal
	
	if !owner.is_on_floor():
		owner.CharGroundCast.force_raycast_update()
		if !owner.CharGroundCast.is_colliding():
			ChangeState("Fall")
			return
		else:
			owner.global_position = owner.CharGroundCast.get_collision_point() + (owner.CharGroundCast.get_collision_normal() * 0.5)
	
	#var DotToGround = (owner.up_direction.dot(owner.GroundCast.target_position.normalized()) + 1.0) / 2.0
	#if owner.Speed < (DotToGround * owner.PARAMETERS.MOVE_GROUND_STICK_REQ_SPEED):
	#	print(DotToGround)
	#	ChangeState("Fall")
	#	return
	
	if Input.is_action_just_pressed("Jump"):
		ChangeState("Jump")
		return
	
	if owner.Speed >= owner.PARAMETERS.SKID_MIN_REQUIRED_SPEED and IsInputSkidding():
		ChangeState("Skid")
		return
	
	if owner.Speed <= owner.PARAMETERS.MOVE_MIN_SPEED:
		ChangeState("Idle")
		return



func IsInputSkidding() -> bool:
	return false
	
	if owner.Controller.InputVelocity.length() > owner.PARAMETERS.SKID_INPUT_MIN:
		var InputDir = owner.velocity.normalized().dot(owner.Controller.InputVelocity)
		if InputDir < owner.PARAMETERS.SKID_ANGLE_MIN:
			print("Skid ratio: %s" % InputDir)
			return true
		
	return false
