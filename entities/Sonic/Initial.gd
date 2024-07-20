extends BasicState




func Enter(_msg := {}) -> void:
	owner.AnimTree.active = true


func Exit() -> void:
	pass


func Update(_delta: float) -> void:
	if owner.is_on_floor():
		ChangeState("Idle")
	else:
		ChangeState("Fall", {})
