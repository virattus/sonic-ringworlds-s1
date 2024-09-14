extends Node


@onready var HUD = $BossHUD
@onready var Options = $IngameOptions
@onready var MusicController = $MusicController
@onready var DeathTimer = $DeathTimer
@onready var player = $Sonic
@onready var boss = $BounceRobotnik
@onready var FightCam = $BossCamera


func _ready() -> void:
	Globals.PlayerChar = player


func _on_death_timer_timeout() -> void:
	if Globals.LivesCount == 0:
		#save current level for respawning
		Globals.CurrentScene = get_tree().current_scene.scene_file_path
		get_tree().change_scene_to_file("res://scenes/ContinueSequence/ContinueSequence.tscn")
	else:
		Globals.LivesCount -= 1
		get_tree().reload_current_scene()


func _on_sonic_health_empty() -> void:
	FightCam.Activate(false)
	DeathTimer.start()


func _on_bounce_robotnik_camera_pan_complete() -> void:
	$StateMachine.ChangeState("Fight")
