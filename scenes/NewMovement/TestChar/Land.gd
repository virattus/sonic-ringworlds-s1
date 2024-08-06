extends BasicState



func Enter(_msg := {}) -> void:
	if owner.velocity.length() > 1.0:
		ChangeState("Run")
	else:
		ChangeState("Idle")


func Exit() -> void:
	pass


func Update(_delta: float) -> void:
	pass
