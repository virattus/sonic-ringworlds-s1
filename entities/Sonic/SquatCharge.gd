extends BasicState


var AccumulatedSpeed := 0.0

func Enter(_msg := {}) -> void:
	owner.AnimTree.set("parameters/Movement/blend_amount", 0.0)
	owner.AnimTree.set("parameters/Ground/blend_amount", 0.0)
	owner.AnimTree.set("parameters/GroundSecondary/blend_amount", -1.0)
	owner.AnimTree.set("parameters/Idle/blend_amount", 1.0)
	
	AccumulatedSpeed = 0.0
	owner.DashModeDrain = false


func Exit() -> void:
	pass



func Update(_delta: float) -> void:
	owner.Move(Vector3.ZERO)
	
	if !owner.is_on_floor():
		ChangeState("Fall", {
		})
		return
	
	#Enter DashMode
	if Input.is_action_just_released("Attack"):
		owner.DashMode = true
		owner.SndSpinLaunch.play()
		owner.DashModeDrain = true
		owner.DashModeCharge = clamp(owner.DashModeCharge, owner.PARAMETERS.DASHMODE_ABS_MIN_CHARGE, owner.PARAMETERS.DASHMODE_ABS_MAX_CHARGE)
		owner.SetVelocity(owner.CharMesh.GetForwardVector() * AccumulatedSpeed)
		ChangeState("StrikeDash", {
		})
		return
	
	if Input.is_action_just_pressed("Jump"):
		owner.SndSpinCharge.play()
		AccumulatedSpeed += owner.PARAMETERS.SQUATCHARGE_ADDED_POWER
