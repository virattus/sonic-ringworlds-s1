extends "res://entities/Player/Fall.gd"



func HandleJumpInput() -> bool:
	if owner.IsUnderwater:
		ChangeState("Jump")
		return false
	else:
		if Input.is_action_just_pressed("Attack"):
			ChangeState("Pose")
			return false
		else:
			ChangeState("Airdash")
			return false
	
	
func HandleAttackInput() -> bool:
	if owner.DashMode:
		ChangeState("SpinKick")
		return false
	else:
		ChangeState("BallAir", {
			"PlayChargeSound": true,
		})
		return false
