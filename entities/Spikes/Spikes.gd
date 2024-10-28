extends Node3D


const SPIKES_DOT_RANGE = -0.3


func _on_hitbox_hitbox_activated(Target: Hurtbox) -> void:
	#TODO better way to get this
	var body : Character = Target.get_parent()
	if global_transform.basis.y.dot(body.velocity.normalized()) < SPIKES_DOT_RANGE:
		Target.ReceiveDamage($Hitbox, 1, false)
		
