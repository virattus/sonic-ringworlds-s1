extends BasicState


var VerticalVelocity := 0.0
var HorizVelocity := Vector3.ZERO


func Enter(_msg := {}) -> void:
	pass
	

func Exit() -> void:
	pass
	

func Update(_delta: float) -> void:

	owner.Move(HorizVelocity + (Vector3.UP * VerticalVelocity))
	
