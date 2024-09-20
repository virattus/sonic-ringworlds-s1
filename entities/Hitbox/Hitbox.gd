class_name Hitbox
extends Area3D


signal HitboxActivated(Target: Hurtbox)

@export var Damage := 1
@export var ApplyDamage := true
@export var ParentCharacter : Character


func _on_area_entered(area: Area3D) -> void:
	if ApplyDamage:
		area.ReceiveDamage(self, Damage)
	HitboxActivated.emit(area)
