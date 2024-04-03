extends BasicState


var Target : Node3D

func Enter(_msg := {}) -> void:
	if _msg.has("Target"):
		Target = _msg["Target"]
	


func Exit() -> void:
	pass


func Update(_delta: float) -> void:
	var NewVel = owner.global_position.direction_to(Target.global_position) * Vector3(1, 0, 1)
	
	owner.Move(NewVel)
	#owner.CharMesh.LerpMeshOrientation(owner.velocity, _delta)


func _on_hurt_box_hurtbox_activated() -> void:
	if ParentStateMachine.ActiveState == self:
		ChangeState("Victory")
