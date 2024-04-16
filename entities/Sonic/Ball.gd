extends BasicState


var VerticalVelocity := 0.0

var IsOnFloor := true

var LastFramePosition := Vector3.ZERO
var LastFramePositionCount := 0.0


const LASTFRAMEPOS_DIST_MAX = 0.05
const LASTFRAMEPOSCOUNT_MAX = 1.0


func _ready() -> void:
	DebugMenu.AddMonitor(self, "VerticalVelocity")
	DebugMenu.AddMonitor(self, "LastFramePosition")
	DebugMenu.AddMonitor(self, "LastFramePositionCount")


func Enter(_msg := {}) -> void:
	owner.SonicModel.visible = false
	owner.SonicBall.visible = true
	
	owner.SndSpinCharge.play()
	
	VerticalVelocity = 0.0
	
	LastFramePosition = owner.global_position
	LastFramePositionCount = 0
	
	IsOnFloor = owner.is_on_floor()


func Exit() -> void:
	owner.SonicModel.visible = true
	owner.SonicBall.visible = false
	
	owner.SndSpinCharge.stop()


func Update(_delta: float) -> void:
	owner.SetVelocity(lerp(owner.velocity, Vector3.ZERO, _delta))
	
	if owner.Speed > owner.PARAMETERS.MOVE_MAX_SPEED:
		owner.SetVelocity(owner.velocity.normalized() * owner.PARAMETERS.MOVE_MAX_SPEED)
	
	owner.Move(owner.velocity + (Vector3.UP * VerticalVelocity))
	
	if owner.global_position.distance_to(LastFramePosition) < LASTFRAMEPOS_DIST_MAX:
		LastFramePositionCount += _delta
	else:
		LastFramePositionCount = 0.0
	
	LastFramePosition = owner.global_position
	
	var VerticalModifier := 0.5
	
	if owner.is_on_floor():
		if !IsOnFloor:
			print("Ball: Hit Ground")
			IsOnFloor = !IsOnFloor
		
		owner.FloorNormal = owner.get_floor_normal()
		owner.up_direction = owner.FloorNormal #owner.up_direction.slerp(owner.FloorNormal, 2.0 * _delta)
		
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
	else:
		if IsOnFloor:
			print("Ball: Left ground")
			IsOnFloor = !IsOnFloor
	
	#print(VerticalModifier)
	VerticalVelocity -= owner.PARAMETERS.GRAVITY * _delta * VerticalModifier

	if LastFramePositionCount > LASTFRAMEPOSCOUNT_MAX:
		ChangeState("Idle")
	
