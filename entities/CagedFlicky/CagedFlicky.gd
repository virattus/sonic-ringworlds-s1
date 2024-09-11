extends Node3D


signal CageDestroyed(ID: int)


@export_range(1, 5) var FlickyID = 0


const EXPLOSION = preload("res://effects/Explosion/Explosion.tscn")
const FLICKY = preload("res://entities/Flicky/Flicky.tscn")


func _on_hurtbox_hurtbox_activated(Source: Hitbox, Damage: int) -> void:
	CageDestroyed.emit(FlickyID - 1)
