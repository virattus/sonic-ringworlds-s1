extends BasicState



func Enter(_msg := {}) -> void:
	pass


func Exit() -> void:
	pass


func Update(_delta: float) -> void:
	get_parent().AirVel.y = owner.PARAMETERS.GRAVITY * _delta * 50.0
	
	var vel = get_parent().AirVel + (owner.Controller.InputVelocity * 10.0)
	if vel.length() > owner.PARAMETERS.AIR_MAX_SPEED:
		vel.move_toward(vel.normalized() * owner.PARAMETERS.AIR_MAX_SPEED, _delta)
	
	owner.Move(vel)
