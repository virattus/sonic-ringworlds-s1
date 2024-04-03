extends BasicState



func Enter(_msg := {}) -> void:
	pass


func Exit() -> void:
	pass


func Update(_delta: float) -> void:
	pass



func _on_player_search_body_entered(body: Node3D) -> void:
	if ParentStateMachine.ActiveState == self:
		ChangeState("Chase", {
			"Target": body,
		})
