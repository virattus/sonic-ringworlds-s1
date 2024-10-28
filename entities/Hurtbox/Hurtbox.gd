class_name Hurtbox
extends Area3D


signal HurtboxActivated(SourcePos: Vector3, Damage: int)


@export var BeDamaged := true
@export var ParentCharacter : Character


func ReceiveDamage(Source: Hitbox, Damage: int, ignorePos: bool) -> void:
	if BeDamaged:
		if ignorePos:
			HurtboxActivated.emit(ParentCharacter.global_position, Damage)
		else:
			HurtboxActivated.emit(Source.global_position, Damage)
