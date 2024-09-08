extends "res://entities/ItemBox/ItemBox.gd"


func ActivateItemBox(source: Character) -> void:
	$SndSpikes.play()
	$Icosphere.visible = false


func _on_hitbox_hitbox_activated(Target: Hurtbox) -> void:
	$SndSpikes.play()
	$Hitbox.monitoring = false
	$Hitbox.monitorable = false


func _on_snd_spikes_finished() -> void:
	queue_free()
