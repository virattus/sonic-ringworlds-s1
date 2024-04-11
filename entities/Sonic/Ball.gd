extends BasicState


var VerticalVelocity := 0.0


func _ready() -> void:
	DebugMenu.AddMonitor(self, "VerticalVelocity")


func Enter(_msg := {}) -> void:
	owner.SonicModel.visible = false
	owner.SonicBall.visible = true
	
	owner.SndSpinCharge.play()
	
	VerticalVelocity = 0.0


func Exit() -> void:
	owner.SonicModel.visible = true
	owner.SonicBall.visible = false
	
	owner.SndSpinCharge.stop()


func Update(_delta: float) -> void:
	owner.SetVelocity(lerp(owner.velocity, Vector3.ZERO, _delta))
	
	if owner.Speed > owner.PARAMETERS.MOVE_MAX_SPEED:
		owner.SetVelocity(owner.velocity.normalized() * owner.PARAMETERS.MOVE_MAX_SPEED)
	
	owner.Move(owner.velocity + (Vector3.UP * VerticalVelocity))
	
	
	var VerticalModifier := 0.5
	
	if owner.is_on_floor():
		owner.FloorNormal = owner.get_floor_normal()
		
		var Dot = owner.FloorNormal.dot(Vector3.DOWN)
		#print(Dot)
		
		if Dot < -0.99:
			if owner.Speed < 1.0:
				ChangeState("Idle")
				return
			else:
				VerticalVelocity = 0.0
				VerticalModifier = 0.0
		else:
			VerticalModifier = (Dot + 1.0) * 0.5
	
	#print(VerticalModifier)
	VerticalVelocity -= owner.PARAMETERS.GRAVITY * _delta * VerticalModifier
		
	owner.up_direction = owner.up_direction.slerp(owner.FloorNormal, _delta)
