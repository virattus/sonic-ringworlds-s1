extends BasicState


var ChosenPos := Vector3.ZERO


func Enter(_msg := {}) -> void:
	ChosenPos = owner.global_position + Vector3(randf(), 0.0, randf()).normalized()


func Exit() -> void:
	pass


func Update(_delta: float) -> void:
	owner.SetVelocity(ChosenPos)
	owner.Move(owner.velocity)
	
	if owner.global_position.distance_to(ChosenPos) < 0.1:
		ChangeState("Idle")
		return
