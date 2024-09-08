extends Area3D




func ActivateItemBox(source: Character) -> void:
	$SndItemBoxOpened.play()
	$Icosphere.visible = false


func _on_hurtbox_hurtbox_activated(_Source: Hitbox, _Damage: int) -> void:
	ActivateItemBox(_Source.get_parent())


func _on_body_entered(body: Node3D) -> void:
	body.AttackHit($Hurtbox, 0.0)
	ActivateItemBox(body)


func _on_snd_item_box_opened_finished() -> void:
	queue_free()
