extends "res://entities/CharController/CharController.gd"


@export var Player: Character
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
	
	InputAnalogueDeadzone = 0.0


func _process(_delta: float) -> void:
	var activeTable = P1Table
	if PlayerID == 1: #2 lol
		activeTable = P2Table
	
	#Movement
	InputAnalogue = Input.get_vector(activeTable["Left"], activeTable["Right"], activeTable["Up"], activeTable["Down"], InputAnalogueDeadzone)
	if InputAnalogue.length() > 1.0:
		InputAnalogue = InputAnalogue.normalized()
	
	#InputVelocity = (Player.CharMesh.global_transform.basis * Vector3(InputAnalogue.x, 0, InputAnalogue.y))

	var floorBasis = Camera_Node.get_node("SpringArm3D/Camera3D").transform.basis
	floorBasis = basis_aligned_y(floorBasis, Player.up_direction)

	InputVelocity = (Camera_Node.CurrentBasis * Vector3(InputAnalogue.x, 0, InputAnalogue.y))
	InputVelocity = floorBasis * InputVelocity

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



func basis_aligned_y(basis_to_align: Basis, vector_to_align_with: Vector3) -> Basis:
	basis_to_align.y = vector_to_align_with
	basis_to_align.x = -basis_to_align.z.cross(basis_to_align.y)
	basis_to_align = basis_to_align.orthonormalized()
	return basis_to_align
