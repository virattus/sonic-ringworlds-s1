class_name Hurtbox
extends Area3D


signal HurtboxActivated(Source: Hitbox, Damage: int)


@export var BeDamaged := true


func ReceiveDamage(Source: Hitbox, Damage: int) -> void:
	if BeDamaged:
		HurtboxActivated.emit(Source, Damage)
