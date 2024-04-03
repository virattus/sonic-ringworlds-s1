extends BasicState


var AccumulatedSpeed := 0.0

func Enter(_msg := {}) -> void:
	owner.AnimTree.set("parameters/Movement/blend_amount", 0.0)
	owner.AnimTree.set("parameters/Ground/blend_amount", 0.0)
	owner.AnimTree.set("parameters/GroundSecondary/blend_amount", -1.0)
	owner.AnimTree.set("parameters/Idle/blend_amount", 1.0)
	
	AccumulatedSpeed = 0.0


func Exit() -> void:
	pass


func Update(_delta: float) -> void:
	if Input.is_action_just_released("Attack"):
		owner.SndSpinLaunch.play()
		ChangeState("StrikeDash", {
			"Speed": AccumulatedSpeed,
		})
		return
	
	if Input.is_action_just_pressed("Jump"):
		owner.SndSpinCharge.play()
		AccumulatedSpeed += owner.PARAMETERS.SQUATCHARGE_ADDED_POWER
