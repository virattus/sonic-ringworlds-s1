extends "res://entities/ItemBox/ItemBox.gd"


func OpenItemBox(source: Character) -> void:
	$SndSpikes.play()
	DeactivateCollision()
	ItemBoxModel.visible = false
	source.DamageReceived(global_position, 1)


func _on_hitbox_hitbox_activated(Target: Hurtbox) -> void:
	OpenItemBox(Target.get_parent())
	


func _on_snd_spikes_finished() -> void:
	queue_free()
