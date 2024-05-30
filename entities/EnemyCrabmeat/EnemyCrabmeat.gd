extends Character



@onready var SndDefeat = $SndDefeat

const EXPLOSION = preload("res://effects/Explosion/Explosion.tscn")
const FLICKY = preload("res://entities/Flicky/Flicky.tscn")


func _on_hurtbox_hurtbox_activated(_Source: Hitbox, _Damage: int) -> void:
	SndDefeat.play()
	var explosion = EXPLOSION.instantiate()
	get_parent().add_child(explosion)
	explosion.global_position = global_position + Vector3(0, 0.5, 0)
	var flicky = FLICKY.instantiate()
	get_parent().add_child(flicky)
	flicky.global_position = global_position + Vector3(0, 0.5, 0)
	queue_free()
	
