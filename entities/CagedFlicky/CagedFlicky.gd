extends Node3D


signal CageDestroyed(ID: int)


@export_range(1, 5) var FlickyID = 0


const EXPLOSION = preload("res://effects/Explosion/Explosion.tscn")
const FLICKY = preload("res://entities/Flicky/Flicky.tscn")


func _on_hurtbox_hurtbox_activated(_Source: Hitbox, Damage: int) -> void:
	CageDestroyed.emit(FlickyID - 1)
	
	var flicky = FLICKY.instantiate()
	get_parent().add_child(flicky)
	flicky.global_position = $Armature/Skeleton3D/BirdBone.global_position
	
	var explosion = EXPLOSION.instantiate()
	get_parent().add_child(explosion)
	explosion.global_position = $Armature/Skeleton3D/CageBone.global_position
	
	queue_free()
