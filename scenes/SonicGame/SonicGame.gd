extends Node


var DrowingMusicPlaying := false

@onready var Player = $Sonic

const PLAYER_DROWNING_MIN = 12.75 / 30.0


func _ready() -> void:
	Globals.RingCount = 0


func _physics_process(delta: float) -> void:
	if !DrowingMusicPlaying and Player.Oxygen <= (PLAYER_DROWNING_MIN):
		$MusicController.DrowningMusicInterrupt()
		DrowingMusicPlaying = true
	
	if DrowingMusicPlaying and Player.Oxygen > (PLAYER_DROWNING_MIN):
		$MusicController.DrowningMusicStop()
		DrowingMusicPlaying = false


func _on_sonic_health_empty() -> void:
	$ThirdPersonCamera.Active = false
	$DeathTimer.start()


func _on_death_timer_timeout() -> void:
	if Globals.LivesCount == 0:
		#save current level for respawning
		Globals.CurrentScene = get_tree().current_scene.scene_file_path
		get_tree().change_scene_to_file("res://scenes/ContinueSequence/ContinueSequence.tscn")
	else:
		Globals.LivesCount -= 1
		get_tree().reload_current_scene()
