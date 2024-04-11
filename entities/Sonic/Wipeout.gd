extends BasicState



func Enter(_msg := {}) -> void:
	owner.AnimTree.set("parameters/Movement/blend_amount", 0.0)
	owner.AnimTree.set("parameters/Ground/blend_amount", 1.0)
	owner.AnimTree.set("parameters/GroundSecondary/blend_amount", 0.0)
	
	owner.SndSkid.play()
	
	owner.up_direction = owner.FloorNormal
	owner.CharMesh.look_at(owner.global_position + owner.velocity.normalized()) 
	
	var curSpeed = owner.Speed
	owner.SetVelocity(owner.CharMesh.GetForwardVector() * curSpeed)
	
	if curSpeed <= owner.PARAMETERS.WIPEOUT_MIN_SLIDE_SPEED:
		owner.SetVelocity(owner.CharMesh.GetForwardVector() * owner.PARAMETERS.WIPEOUT_MIN_SLIDE_SPEED)
	
	owner.CharMesh.look_at(owner.global_position + owner.velocity.normalized())
	owner.CharMesh.AlignToY(owner.FloorNormal)



func Exit() -> void:
	owner.SndSkid.stop()


func Update(_delta: float) -> void:
	owner.SetVelocity(lerp(owner.velocity, Vector3.ZERO, owner.PARAMETERS.WIPEOUT_SPEED_REDUCTION_RATE * _delta))
	
	owner.Move(owner.velocity)
	owner.CharMesh.look_at(owner.global_position + owner.velocity.normalized()) 
	
	if owner.is_on_floor():
		owner.FloorNormal = owner.get_floor_normal()
		owner.up_direction = owner.FloorNormal
		owner.CharMesh.AlignToY(owner.FloorNormal)
	else:
		ChangeState("Fall")
		return
		
	
	if owner.Speed <= owner.PARAMETERS.WIPEOUT_MIN_SPEED:
		ChangeState("Idle")
		return
