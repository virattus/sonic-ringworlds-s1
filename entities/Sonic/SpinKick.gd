extends BasicState


var JumpVel := Vector3.ZERO
var InputVel := Vector3.ZERO
var InputSpeed := 0.0
var VerticalVelocity := 0.0


func Enter(_msg := {}) -> void:
	owner.AnimTree.set("parameters/AirSpinKick/blend_amount", 1.0)
	owner.AttackArea.monitoring = true
	
	if _msg.has("JumpVel"):
		JumpVel = _msg["JumpVel"]
	else:
		print("Fall: using current velocity")
		JumpVel = owner.velocity

	if _msg.has("InputVel"):
		InputVel = _msg["InputVel"]
	else:
		InputVel = Vector3.ZERO
	
	if _msg.has("InputSpeed"):
		InputSpeed = _msg["InputSpeed"]
	else:
		InputSpeed = 0.0


func Exit() -> void:
	owner.AnimTree.set("parameters/AirSpinKick/blend_amount", 0.0)
	owner.AttackArea.monitoring = false
	
	owner.FloorNormal = Vector3.UP
	owner.up_direction = Vector3.UP


func Update(_delta: float) -> void:
	InputVel += owner.Controller.InputVelocity * _delta
	if InputVel.length() > owner.PARAMETERS.JUMP_INPUT_VEL_MAX:
		InputVel = InputVel.normalized() * owner.PARAMETERS.JUMP_INPUT_VEL_MAX
	
	var vel = JumpVel + (InputVel * InputSpeed)
	if vel.length() > owner.PARAMETERS.AIR_MAX_SPEED:
		vel.move_toward(vel.normalized() * owner.PARAMETERS.AIR_MAX_SPEED, _delta)
	
	VerticalVelocity -= owner.PARAMETERS.GRAVITY * _delta
	
	owner.SetVelocity((Vector3.UP * VerticalVelocity))
	owner.Move(owner.velocity)

	
	if owner.is_on_floor():
		ChangeState("Land")
		return

