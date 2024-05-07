extends Area3D




func _on_body_entered(body: Node3D) -> void:
	assert(body.is_in_group("Player"))
	body.StateM.ChangeState("Death")
