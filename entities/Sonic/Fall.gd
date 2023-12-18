extends "res://entities/Sonic/AirMove.gd"



func Enter(_msg := {}) -> void:
	super(_msg)
	VerticalVelocity = 0.0
	owner.Controller.JumpJustPressed.connect(HandleJump)


func Exit() -> void:
	super()
	owner.Controller.JumpJustPressed.disconnect(HandleJump)


func Update(_delta: float) -> void:
	if owner.GroundCollision:
		ChangeState("Land")
		return
	
	#if owner.Controller.InputJump == CharController.BUTTON_JUST_PRESSED:
	#	if (owner.velocity * Vector3(1, 0, 1)).length() > owner.MIN_FLIGHT_VEL:
	#		ChangeState("Fly")
	#		return
	#	else:
	#		ChangeState("Flap")
	#		return
	
	super(_delta)


func HandleJump() -> void:
	#ChangeState("Fly")
	return
