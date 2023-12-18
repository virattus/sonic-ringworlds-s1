extends BasicState


var Pause := true
var PauseAccumulator := 0.0
var LeftGround := false
var VerticalVelocity := 0.0
var InitialVelocity := Vector3.ZERO
var CameraPosition := Vector3.ZERO


func Enter(_msg := {}) -> void:
	InitialVelocity = -owner.CharMesh.GetForwardVector().normalized()
	VerticalVelocity = owner.PARAMETERS.HURT_VERT_VELOCITY_START
	owner.global_position += Vector3(0.0, 0.1, 0.0) #keep getting stuck in ground, should test against the ceiling
	

func Exit() -> void:
	Pause = true
	PauseAccumulator = 0.0
	LeftGround = false


func Update(_delta: float) -> void:
	if Pause:
		if PauseAccumulator > owner.PARAMETERS.HURT_PAUSE_DURATION:
			Pause = false
		else:
			PauseAccumulator += _delta
		return
	
	if LeftGround and owner.GroundCollision:
		ChangeState("Idle")
		return
	
	if !LeftGround:
		if !owner.GroundCollision:
			LeftGround = true

	VerticalVelocity -= owner.Gravity * _delta
	
	owner.Move((InitialVelocity * owner.PARAMETERS.HURT_HORIZ_VELOCITY) + (Vector3(0, VerticalVelocity, 0)))
	owner.CharMesh.LerpMeshOrientation(-InitialVelocity, _delta)
