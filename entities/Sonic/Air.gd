extends ComplexState


var AirVel := Vector3.ZERO
var InputVel := Vector3.ZERO


func _ready() -> void:
	super()
	DebugMenu.AddMonitor(self, "AirVel")
	DebugMenu.AddMonitor(self, "InputVel")


func Enter(_msg := {}) -> void:
	owner.GroundCollision = false
	owner.AnimTree.set("parameters/Movement/blend_amount", 1.0)
	owner.GroundCast.target_position = Vector3.DOWN * owner.GroundCastLength
	
	if _msg.has("AirVel"):
		AirVel = _msg["AirVel"]
	else:
		AirVel = Vector3.ZERO
	
	if _msg.has("InputVel"):
		InputVel = _msg["InputVel"]
	else:
		InputVel = Vector3.ZERO
	
	super(_msg)


func Exit() -> void:
	super()


func Update(_delta: float) -> void:
	#UpdateInput(_delta)
	#var inputVel = (InputVel * InputSpeed) if AddPlayerInput else Vector3.ZERO
	#AirMove(_delta, inputVel)
	super(_delta)


func UpdateInput(_delta: float) -> void:
	InputVel += owner.Controller.InputVelocity * _delta
	if InputVel.length() > owner.PARAMETERS.JUMP_INPUT_VEL_MAX:
		InputVel = InputVel.normalized() * owner.PARAMETERS.JUMP_INPUT_VEL_MAX


func AirMove(_delta: float, additionalInput:= Vector3.ZERO) -> void:
	AirVel.y -= owner.PARAMETERS.GRAVITY * _delta * (0.5 if Input.is_action_pressed("Jump") else 1.0)
	
	var vel = AirVel + (additionalInput)
	if vel.length() > owner.PARAMETERS.AIR_MAX_SPEED:
		vel.move_toward(vel.normalized() * owner.PARAMETERS.AIR_MAX_SPEED, _delta)
	
	owner.Move(vel)
