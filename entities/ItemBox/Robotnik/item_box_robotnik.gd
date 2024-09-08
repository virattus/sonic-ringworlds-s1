extends "res://entities/ItemBox/ItemBox.gd"


func ActivateItemBox(source: Character) -> void:
	$SndSpikes.play()
	DeactivateCollision()
	ItemBoxModel.visible = false
	source.DamageReceived(global_position, 1)



func _on_hitbox_hitbox_activated(Target: Hurtbox) -> void:
	ActivateItemBox(Target.get_parent())
	


func _on_snd_spikes_finished() -> void:
	queue_free()
