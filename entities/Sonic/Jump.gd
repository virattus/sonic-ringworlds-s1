extends "res://entities/Sonic/AirMove.gd"



func Enter(_msg := {}) -> void:
	$JumpSound.play()
	
	VerticalVelocity = owner.JUMP_POWER

	super(_msg)


func Exit() -> void:
	super()


func Update(_delta: float) -> void:
	if VerticalVelocity < 0.0:
		ChangeState("Fall")
	
	super(_delta)
