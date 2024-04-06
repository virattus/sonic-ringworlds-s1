extends BasicState



func Enter(_msg := {}) -> void:
	owner.AnimTree.set("parameters/Movement/blend_amount", 0.0)
	owner.AnimTree.set("parameters/Ground/blend_amount", 1.0)
	owner.AnimTree.set("parameters/GroundSecondary/blend_amount", 1.0)
	
	owner.SndSkid.play()


func Exit() -> void:
	owner.SndSkid.stop()


func Update(_delta: float) -> void:
	owner.velocity = lerp(owner.velocity, Vector3.ZERO, owner.PARAMETERS.SKID_SPEED_REDUCTION_RATE * _delta)
	
	if !owner.is_on_floor():
		owner.velocity.y -= owner.PARAMETERS.GRAVITY * _delta
	
	owner.Move(owner.velocity)
	
	if !owner.is_on_floor():
		ChangeState("Fall")
		return
	
	if owner.Speed <= owner.PARAMETERS.SKID_END_MIN_SPEED:
		ChangeState("Idle")
		return
 
