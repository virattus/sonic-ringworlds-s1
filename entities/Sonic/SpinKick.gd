extends BasicState


var VerticalVelocity := 0.0


func Enter(_msg := {}) -> void:
	pass


func Exit() -> void:
	pass


func Update(_delta: float) -> void:
	VerticalVelocity -= owner.PARAMETERS.GRAVITY * _delta
	
	owner.SetVelocity((Vector3.UP * VerticalVelocity))
	owner.Move()

	
	if owner.is_on_floor():
		ChangeState("Land")

