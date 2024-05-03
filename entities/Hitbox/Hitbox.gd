class_name Hitbox
extends Area3D


signal HitboxActivated(Target: Hurtbox)

@export var Damage := 1


func _on_area_entered(area: Area3D) -> void:
	area.ReceiveDamage(self, Damage)
	HitboxActivated.emit(area)
