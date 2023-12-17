extends BasicState


var Direction := Vector3.ZERO
var Speed := 0.0


func Enter(_msg := {}) -> void:
	Direction = owner.velocity * Vector3(1, 0, 1)


func Exit() -> void:
	pass


func Update(_delta: float) -> void:
	Speed = lerp(Speed, owner.DASH_MAX_SPEED, _delta * 2.75)
	
	owner.Move(Direction.normalized() * Speed)
	owner.CharMesh.LerpMeshOrientation(owner.velocity, _delta)


func _on_dash_life_timer_timeout() -> void:
	if owner.InputIsSkidding():
		ChangeState("SkidStop")
		return
	else:
		ChangeState("Move")
