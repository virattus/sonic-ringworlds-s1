extends BasicState




func Enter(_msg := {}) -> void:
	owner.AnimTree.active = true
	if owner.is_on_floor():
		ChangeState("Idle")
	else:
		ChangeState("Fall")


func Exit() -> void:
	pass


func Update(_delta: float) -> void:
	pass
