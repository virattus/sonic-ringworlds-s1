extends Area3D


signal HurtboxActivated

@export var Damage := 1



func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("Character"):
		body.ReceiveDamage(Damage)
	
	HurtboxActivated.emit()
