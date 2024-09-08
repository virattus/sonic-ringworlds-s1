extends Area3D


@onready var ItemBoxModel = $ItemBoxClassic


func ActivateItemBox(source: Character) -> void:
	$SndItemBoxOpened.play()
	ItemBoxModel.visible = false
	DeactivateCollision()
	


func DeactivateCollision() -> void:
	$CollisionShape3D.set_deferred("disabled", true)
	$Hurtbox/CollisionShape3D.set_deferred("disabled", true)


func _on_hurtbox_hurtbox_activated(_Source: Hitbox, _Damage: int) -> void:
	ActivateItemBox(_Source.get_parent())


func _on_body_entered(body: Node3D) -> void:
	body.AttackHit($Hurtbox, 0.0)
	ActivateItemBox(body)


func _on_snd_item_box_opened_finished() -> void:
	queue_free()
