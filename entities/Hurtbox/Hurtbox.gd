class_name Hurtbox
extends Area3D


signal HurtboxActivated(Source: Hitbox, Damage: int)


@export var BeDamaged := true
@export var ParentCharacter : Character


func ReceiveDamage(Source: Hitbox, Damage: int) -> void:
	if BeDamaged:
		HurtboxActivated.emit(Source, Damage)
