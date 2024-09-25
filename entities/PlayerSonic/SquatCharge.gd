extends "res://entities/Player/MoveGround.gd"


var ChargePower := 0.0

const CHARGE_MAX_POWER = 20.0
const CHARGE_POWER_GENERATE_POWER = 200.0
const CHARGE_POWER_IDLE_DRAIN = 0.0


func Enter(_msg := {}) -> void:
	owner.AnimTree.set("parameters/Movement/blend_amount", 0.0)
	owner.AnimTree.set("parameters/Ground/blend_amount", 0.0)
	owner.AnimTree.set("parameters/GroundSecondary/blend_amount", -1.0)
	owner.AnimTree.set("parameters/Idle/blend_amount", 1.0)
	
	owner.DashModeDrain = false
	owner.SetVelocity(Vector3.ZERO)


func Exit() -> void:
	ChargePower = 0.0



func Update(_delta: float) -> void:
	if !HandleMovementAndCollisions(_delta):
		return

	if Input.is_action_just_released("Attack"):
		print("Strikedash with power %s" % ChargePower)
		if ChargePower > 0.0:
			LaunchStrikeDash()
			return
		else:
			ChangeState("Idle")
			return

	ChargePower = clamp(ChargePower - CHARGE_POWER_IDLE_DRAIN * _delta, 0.0, CHARGE_MAX_POWER)
	
	if Input.is_action_just_pressed("Jump"):
		owner.SndSpinCharge.play()
		ChargePower += CHARGE_POWER_GENERATE_POWER * _delta


func LaunchStrikeDash() -> void:
	owner.SndSpinLaunch.play()
	if owner.DashModeCharge >= 1.0:
		owner.SetDashMode(true)
	#owner.DashModeCharge = clamp(owner.DashModeCharge, owner.PARAMETERS.DASHMODE_ABS_MIN_CHARGE, owner.PARAMETERS.DASHMODE_ABS_MAX_CHARGE)
	owner.SetVelocity(owner.CharMesh.GetForwardVector() * ChargePower)
	ChangeState("Move")
