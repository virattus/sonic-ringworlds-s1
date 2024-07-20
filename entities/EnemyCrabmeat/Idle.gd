extends BasicState



func Enter(_msg := {}) -> void:
	owner.AnimPlayer.play("Crab_Idle")
	$Timer.start(randf() + 0.5)


func Exit() -> void:
	pass


func Update(_delta: float) -> void:
	pass



func _on_player_search_body_entered(body: Node3D) -> void:
	return
	if ParentStateMachine.ActiveState == self:
		ChangeState("Chase", {
			"Target": body,
		})


func _on_timer_timeout() -> void:
	ChangeState("Wander")
