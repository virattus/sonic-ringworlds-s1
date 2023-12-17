extends BasicState


var Speed := 0.0
var TimeSinceStart := 0


const MIN_INPUT_LENGTH = 0.8
const SPEED_MULTIPLIER = 3.0



func Enter(_msg := {}) -> void:
	if _msg["PrevState"] == "Idle":
		$DashTimer.start()
	
	if _msg.has("Speed"):
		Speed = _msg["Speed"]
	else:
		Speed = owner.Speed
	
	owner.Controller.JumpJustPressed.connect(HandleJump)
	owner.Controller.AttackJustPressed.connect(HandleAttack)


func Exit() -> void:
	TimeSinceStart = 0
	owner.Controller.JumpJustPressed.disconnect(HandleJump)
	owner.Controller.AttackJustPressed.disconnect(HandleAttack)
	

func Update(_delta: float) -> void:
	if !owner.GroundCollision:
		ChangeState("Fall")
		return
	
	#if owner.Controller.InputJump == CharController.BUTTON_JUST_PRESSED:
	#	ChangeState("Jump")
	#	return
	
	if owner.Controller.InputVelocity.length() > 0.0:
		Speed += owner.MOVE_SPEED_ADD_MODIFIER * _delta * owner.Controller.InputVelocity.length()
		if Speed > owner.SPRINT_MAX_SPEED:
			Speed = owner.SPRINT_MAX_SPEED
		elif Speed > owner.RUN_MAX_SPEED:
			Speed += owner.MOVE_SPEED_SUB_MODIFIER * _delta * 0.45
	else:
		Speed += owner.MOVE_SPEED_SUB_MODIFIER * _delta
		if Speed <= 0.0:
			ChangeState("Idle")
			return
	
	if owner.InputIsSkidding():
		if owner.Speed > owner.WALK_MAX_SPEED:
			ChangeState("SkidStop")
			return
		else:
			Speed += owner.MOVE_SPEED_SUB_MODIFIER * _delta
			if Speed <= 0.0:
				ChangeState("Idle")
				return
	
	var vel = owner.velocity.normalized()
	
	#As the character speeds up, we want the controller input's "weight" to reduce
	vel = ((vel * Speed) + owner.Controller.InputVelocity).normalized() 
	
	owner.Move(vel * Speed)
	
	var orientation = (owner.Controller.InputVelocity + (owner.velocity.normalized() * owner.Speed * owner.MOVE_STICK_VEL_RATIO_MODIFIER)).normalized()
	
	owner.CharMesh.LerpMeshOrientation(orientation, _delta)
	
	Speed = owner.Speed


func _on_dash_timer_timeout() -> void:
	return
	if owner.Controller.InputVelocity.length() > 0.9:
		ChangeState("Dash")


func HandleJump() -> void:
	ChangeState("Jump")


func HandleAttack() -> void:
	return
