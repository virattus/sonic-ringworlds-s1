extends BasicState



func Enter(_msg := {}) -> void:
	owner.AnimTree.set("parameters/Movement/blend_amount", 0.0)
	owner.AnimTree.set("parameters/Ground/blend_amount", 1.0)
	owner.AnimTree.set("parameters/GroundSecondary/blend_amount", 0.0)
	
	owner.SndSkid.play()
	
	#owner.FloorNormal = owner.get_floor_normal()
	owner.up_direction = owner.FloorNormal
	
	if owner.Speed <= 0.0:
		owner.velocity = owner.CharMesh.GetForwardVector().normalized() * 3.0
		owner.Speed = owner.velocity.length() #maybe have a function handle this
	


func Exit() -> void:
	owner.SndSkid.stop()


func Update(_delta: float) -> void:
	owner.velocity = lerp(owner.velocity, Vector3.ZERO, owner.PARAMETERS.WIPEOUT_SPEED_REDUCTION_RATE * _delta)
	
	if owner.Speed <= owner.PARAMETERS.WIPEOUT_MIN_SLIDE_SPEED:
		ChangeState("Idle")
		return
	
	owner.Move(owner.velocity)
	owner.CharMesh.look_at(owner.global_position + owner.velocity)
