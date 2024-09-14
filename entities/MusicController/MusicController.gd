extends Node


signal ActClearMusicFinished


func PlayMusic(musicSource) -> void:
	pass


func DrowningMusicInterrupt() -> void:
	$MusicActiveTrack.stream_paused = true
	$MusicDrowning.play()


func DrowningMusicStop() -> void:
	$MusicDrowning.stop()
	$MusicActiveTrack.stream_paused = false


func ActClearMusicInterrupt() -> void:
	$MusicActiveTrack.stream_paused = true
	$MusicActClear.play()


func _on_music_act_clear_finished() -> void:
	ActClearMusicFinished.emit()
