class_name PlayerSwapper
extends Node3D


signal PlayerDeath
signal PlayerSwap(active: bool)


enum CHAR_SELECT {
	NONE,
	SONIC,
	TAILS,
	KNUCKLES,
	AMY,
}


@export var Cam : ThirdPersonCamera
@export var CamFocus : CameraFocus
@export var CurrentPlayer : Player

var Selection := CHAR_SELECT.NONE

const SONIC = preload("res://entities/PlayerSonic/PlayerSonic.tscn")
const TAILS = preload("res://entities/PlayerTails/PlayerTails.tscn")
const KNUCKLES = preload("res://entities/PlayerKnuckles/PlayerKnuckles.tscn")
const AMY = preload("res://entities/PlayerAmy/PlayerAmy.tscn")


func _ready() -> void:
	assert(CurrentPlayer)
	
	BindCameraFocus()
	Cam.Focus = CamFocus
	
	CurrentPlayer.HealthEmpty.connect(CharDeath)


func _physics_process(delta: float) -> void:
	if Input.is_action_just_released("Swap"):
		if Selection == CHAR_SELECT.NONE:
			return
		SwapCharacter(Selection)
	
	if Input.is_action_pressed("Swap"):
		var dir : Vector2 = Input.get_vector("Move_Left", "Move_Right", "Move_Forward", "Move_Backward").normalized()
		if dir.length() > 0.0:
			if absf(dir.x) > absf(dir.y):
				if signf(dir.x) > 0.0:
					Selection = CHAR_SELECT.SONIC
				else:
					Selection = CHAR_SELECT.AMY
			else:
				if signf(dir.y) > 0.0:
					Selection = CHAR_SELECT.KNUCKLES
				else:
					Selection = CHAR_SELECT.TAILS
		



func SwapCharacter(char: CHAR_SELECT) -> void:
	PlayerSwap.emit(true)
	
	Cam.Active = false
	
	CurrentPlayer.HealthEmpty.disconnect(CharDeath)
	var CurrentTransform : Transform3D = CurrentPlayer.global_transform
	var CurrentState : String = CurrentPlayer.StateM.CurrentState
	remove_child(CurrentPlayer)
	CurrentPlayer.queue_free()
	
	match char:
		CHAR_SELECT.SONIC:
			CurrentPlayer = SONIC.instantiate()
		CHAR_SELECT.TAILS:
			CurrentPlayer = TAILS.instantiate()
		CHAR_SELECT.KNUCKLES:
			CurrentPlayer = KNUCKLES.instantiate()
		CHAR_SELECT.AMY:
			CurrentPlayer = AMY.instantiate()
		
	add_child(CurrentPlayer)
	
	#post swap
	BindCameraFocus()
	Cam.Char = CurrentPlayer
	CurrentPlayer.Camera = Cam
	CurrentPlayer.HealthEmpty.connect(CharDeath)
	
	CurrentPlayer.global_transform = CurrentTransform
	CurrentPlayer.StateM.ChangeState(CurrentState)

	Cam.Active = true

	PlayerSwap.emit(false)


func CharDeath() -> void:
	PlayerDeath.emit()


func BindCameraFocus() -> void:
	CamFocus.get_parent().remove_child(CamFocus)
	CurrentPlayer.add_child(CamFocus)
	CamFocus.Target = CurrentPlayer
