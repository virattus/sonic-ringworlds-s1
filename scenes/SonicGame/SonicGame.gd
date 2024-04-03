extends Node


func _on_sonic_health_empty() -> void:
	$ThirdPersonCamera.Active = false
	$DeathTimer.start()


func _on_death_timer_timeout() -> void:
	get_tree().reload_current_scene()
