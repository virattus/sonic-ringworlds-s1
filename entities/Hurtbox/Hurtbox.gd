class_name Hurtbox
extends Area3D


signal HurtboxActivated(Source: Hitbox, Damage: int)


func ReceiveDamage(Source: Hitbox, Damage: int) -> void:
	HurtboxActivated.emit(Source, Damage)
