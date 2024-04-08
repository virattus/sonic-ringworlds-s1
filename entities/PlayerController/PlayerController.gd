extends "res://entities/CharController/CharController.gd"


@export var Camera_Node: ThirdPersonCamera
@export_enum("1", "2") var PlayerID: int

var P1Table = {
	"Left": "Move_Left",
	"Right": "Move_Right",
	"Up": "Move_Forward",
	"Down": "Move_Backward",
	"Jump": "Jump",
	"Attack": "Attack",
}

var P2Table = {
	"Left": "P2_Move_Left",
	"Right": "P2_Move_Right",
	"Up": "P2_Move_Forward",
	"Down": "P2_Move_Backward",
	"Jump": "P2_Jump",
	"Attack": "P2_Attack",
}


func _ready() -> void:
	DebugMenu.AddMonitor(self, "InputAnalogue")
	DebugMenu.AddMonitor(self, "InputAnalogueDeadzone")
	DebugMenu.AddMonitor(self, "InputVelocity")
	DebugMenu.AddMonitor(self, "InputJump")
	DebugMenu.AddMonitor(self, "InputAttack")
	
	InputAnalogueDeadzone = 0.2


func _process(_delta: float) -> void:
	var activeTable = P1Table
	if PlayerID == 1: #2 lol
		activeTable = P2Table
	
	#Movement
	var InputMove := Input.get_vector(activeTable["Left"], activeTable["Right"], activeTable["Up"], activeTable["Down"], InputAnalogueDeadzone)
	if InputMove.length() > 1.0:
		InputMove = InputMove.normalized()
	
	InputAnalogue = InputMove
	
	#var CameraFront = (Camera_Node.basis.z * Vector3(1, 1, 1)).normalized()
	#var CameraRight = (Camera_Node.basis.x * Vector3(1, 1, 1)).normalized()
	
	#var newMovement = (CameraFront * InputMove.y) + (CameraRight * InputMove.x)
	var newMovement = (Camera_Node.CurrentBasis * Vector3(InputMove.x, 0, InputMove.y))
	
	InputVelocity = newMovement

	if Input.is_action_just_pressed(activeTable["Jump"]):
		JumpJustPressed.emit()
		InputJump = BUTTON_JUST_PRESSED
	elif Input.is_action_pressed(activeTable["Jump"]):
		JumpPressed.emit()
		InputJump = BUTTON_PRESSED
	elif Input.is_action_just_released(activeTable["Jump"]):
		JumpJustReleased.emit()
		InputJump = BUTTON_JUST_RELEASED
	else:
		InputJump = BUTTON_RELEASED
		
		
	if Input.is_action_just_pressed(activeTable["Attack"]):
		AttackJustPressed.emit()
		InputAttack = BUTTON_JUST_PRESSED
	elif Input.is_action_pressed(activeTable["Attack"]):
		AttackPressed.emit()
		InputAttack = BUTTON_PRESSED
	elif Input.is_action_just_released(activeTable["Attack"]):
		AttackJustReleased.emit()
		InputAttack = BUTTON_JUST_RELEASED
	else:
		InputAttack = BUTTON_RELEASED
