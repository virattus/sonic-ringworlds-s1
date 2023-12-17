extends BasicState


var LeftGround := false
var VerticalVelocity := 0.0
var InitialVelocity := Vector3.ZERO
var BlinkInterval := 0.0


func Enter(_msg := {}) -> void:
	InitialVelocity = -owner.CharMesh.GetForwardVector().normalized()
	VerticalVelocity = owner.HURT_VERT_VELOCITY_START
	owner.set_collision_layer_value(2, false)
	owner.global_position += Vector3(0.0, 0.1, 0.0) #keep getting stuck in ground, should test against the ceiling


func Exit() -> void:
	BlinkInterval = 0.0
	owner.CharMesh.visible = true
	LeftGround = false
	owner.set_collision_layer_value(2, true)
	

func Update(_delta: float) -> void:
	if BlinkInterval > owner.HURT_BLINK_INTERVAL:
		BlinkInterval -= owner.HURT_BLINK_INTERVAL
		owner.CharMesh.visible = !owner.CharMesh.visible
	BlinkInterval += _delta
	
	if LeftGround and owner.GroundCollision:
		ChangeState("Idle")
		return
	
	if !LeftGround:
		if !owner.GroundCollision:
			LeftGround = true

	VerticalVelocity -= owner.Gravity * _delta
	
	owner.Move((InitialVelocity * owner.HURT_HORIZ_VELOCITY) + (Vector3(0, VerticalVelocity, 0)))
	owner.CharMesh.LerpMeshOrientation(-InitialVelocity, _delta)
