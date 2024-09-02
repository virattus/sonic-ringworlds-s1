extends Node



func PlayMusic(musicSource) -> void:
	pass


func DrowningMusicInterrupt() -> void:
	$MusicActiveTrack.stream_paused = true
	$MusicDrowning.play()


func DrowningMusicStop() -> void:
	$MusicDrowning.stop()
	$MusicActiveTrack.stream_paused = false
