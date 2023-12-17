extends "res://entities/CharController/CharController.gd"


@export var Camera_Node = Node3D
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

var Deadzone := 0.1


func _ready() -> void:
	DebugMenu.AddMonitor(self, "InputVelocity")
	DebugMenu.AddMonitor(self, "InputJump")
	DebugMenu.AddMonitor(self, "InputAttack")


func _process(_delta: float) -> void:
	var activeTable = P1Table
	if PlayerID == 1: #2 lol
		activeTable = P2Table
	
	#Movement
	var InputMove := Input.get_vector(activeTable["Left"], activeTable["Right"], activeTable["Up"], activeTable["Down"])
	if InputMove.length() > 1.0:
		InputMove = InputMove.normalized()
	elif InputMove.length() < Deadzone:
		InputMove = Vector2.ZERO
	
	var CameraFront = (Camera_Node.GetCameraBasis().z * Vector3(1, 0, 1)).normalized()
	var CameraRight = (Camera_Node.GetCameraBasis().x * Vector3(1, 0, 1)).normalized()
	
	var newMovement = (CameraFront * InputMove.y) + (CameraRight * InputMove.x)
	
	InputVelocity = newMovement

	if Input.is_action_just_pressed(activeTable["Jump"]):
		JumpJustPressed.emit()
		InputJump = BUTTON_JUST_PRESSED
	elif Input.is_action_pressed(activeTable["Jump"]):
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
		InputAttack = BUTTON_PRESSED
	elif Input.is_action_just_released(activeTable["Attack"]):
		AttackJustReleased.emit()
		InputAttack = BUTTON_JUST_RELEASED
	else:
		InputAttack = BUTTON_RELEASED
