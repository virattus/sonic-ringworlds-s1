extends "res://entities/Player/Move.gd"



func HandleJumpInput() -> bool:
	ChangeState("Jump", {
		"JumpSound": true,
	})
	return false


func HandleAttackInput() -> bool:
	ChangeState("Ball", {
		"PlayChargeSound": true,
	})
	return false
