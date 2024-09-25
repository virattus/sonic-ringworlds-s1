extends Node


@onready var player = $PlayerSwapper/PlayerSonic
@onready var enemies = $Enemies


func _ready() -> void:
	$TitleCard.visible = true
	Globals.RingCount = 0
	Globals.CollectedFlickies = [false, false, false, false, false]


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


func _on_caged_flicky_cage_destroyed(ID: int) -> void:
	$HUD.ActivateFlickyIcon(ID)


func _on_title_card_title_card_anim_complete() -> void:
	$StateMachine.ChangeState("Gameplay")


func _on_player_play_drowning_music(play: bool) -> void:
	if play:
		$MusicController.DrowningMusicInterrupt()
	else:
		$MusicController.DrowningMusicStop()
