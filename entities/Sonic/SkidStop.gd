extends BasicState


var InitialVelocity := Vector3.ZERO


const MIN_VEL_TO_IDLE = 1.0


func Enter(_msg := {}) -> void:
	$SkidSound.play()
	if _msg.has("Speed"):
		InitialVelocity = owner.velocity.normalized() * _msg["Speed"]
	else:
		InitialVelocity = owner.velocity.normalized() * owner.Speed


func Exit() -> void:
	$SkidSound.stop()


func Update(_delta: float) -> void:
	owner.Move(lerp(owner.velocity, Vector3.ZERO, _delta * owner.SKID_SPEED_LERP_MODIFIER))

	if !owner.GroundCollision:
		ChangeState("Fall")
		return
	
	if owner.velocity.length() <= MIN_VEL_TO_IDLE:
		ChangeState("Idle")
		return
		

