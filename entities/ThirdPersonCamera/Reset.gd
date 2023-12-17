extends BasicState



var ResetAngle := Vector2.ZERO
var ReturnState := "Manual"


const MIN_ROT_VALUE = 0.01
const ROT_LERP_SPEED = 20.0


func Enter(_msg := {}) -> void:
	#ResetAngle = Vector2(owner.rotation.y, -0.25)
	
	if _msg.has("ResetAngle"):
		ResetAngle = _msg["ResetAngle"]
	else:
		printerr("Camera reset called without a reset angle")
		ResetAngle = Vector2.ZERO
	if _msg.has("ReturnState"):
		ReturnState = _msg["ReturnState"]
	

func Exit() -> void:
	pass
	

func Update(_delta: float) -> void:
	if AngleDifference(ResetAngle.x, owner.Rot.x) <= MIN_ROT_VALUE:
		owner.Rot = ResetAngle
		ChangeState(ReturnState)
		return
	
	owner.Rot.x = lerp_angle(owner.Rot.x, ResetAngle.x, ROT_LERP_SPEED * _delta)
	owner.Rot.y = lerp(owner.Rot.y, ResetAngle.y, ROT_LERP_SPEED * _delta)
	owner.UpdateRotation()
	owner.global_position = owner.Target.global_position


#TODO figure out if there's a built in way to do this
func AngleDifference(a: float, b: float) -> float:
	var phi = fmod(abs(b - a), TAU)
	return TAU - phi if phi > PI else phi
