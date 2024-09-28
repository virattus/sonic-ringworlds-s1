class_name PlayerSwapper
extends Node3D


signal PlayerDeath


@export var Cam : ThirdPersonCamera
@export var CamFocus : CameraFocus
@export var CurrentPlayer : Player


const SONIC = preload("res://entities/PlayerSonic/PlayerSonic.tscn")
const TAILS = preload("res://entities/PlayerTails/PlayerTails.tscn")
const KNUCKLES = preload("res://entities/PlayerKnuckles/PlayerKnuckles.tscn")
const AMY = preload("res://entities/PlayerAmy/PlayerAmy.tscn")


func _ready() -> void:
	assert(CurrentPlayer)
	
	CamFocus.Target = CurrentPlayer
	Cam.Focus = CamFocus
	
	CurrentPlayer.HealthEmpty.connect(CharDeath)


func SwapCharacter() -> void:
	CurrentPlayer.HealthEmpty.disconnect(CharDeath)
	
	#post swap
	CamFocus.Target = CurrentPlayer
	CurrentPlayer.Camera = Cam
	CurrentPlayer.HealthEmpty.connect(CharDeath)


func CharDeath() -> void:
	PlayerDeath.emit()
