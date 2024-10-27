extends Node


signal ActClearMusicFinished

@export var StageMusic : AudioStream


@onready var MusicActiveTrack = $MusicActiveTrack


func _ready() -> void:
	PlayMusic()


func PlayMusic() -> void:
	if StageMusic == null:
		return
	
	MusicActiveTrack.stream = StageMusic
	MusicActiveTrack.play()


func DrowningMusicStart() -> void:
	$MusicActiveTrack.stream_paused = true
	$MusicDrowning.play()


func DrowningMusicStop() -> void:
	$MusicDrowning.stop()
	$MusicActiveTrack.stream_paused = false


func ActClearMusicStart() -> void:
	$MusicActiveTrack.stream_paused = true
	$MusicActClear.play()


func ActClearMusicStop() -> void:
	$MusicActClear.stop()
	$MusicActiveTrack.play(0.0)


func _on_music_act_clear_finished() -> void:
	ActClearMusicFinished.emit()


func _on_music_speedup_finished() -> void:
	$MusicActiveTrack.stream_paused = false
