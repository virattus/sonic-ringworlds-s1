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
	owner.ToggleHitbox(true)
	
	owner.SndSpinCharge.play()
	
	VerticalVelocity = 0.0
	
	LastFramePosition = owner.global_position
	LastFramePositionCount = 0
	
	IsOnFloor = owner.is_on_floor()


func Exit() -> void:
	owner.SonicModel.visible = true
	owner.SonicBall.visible = false
	owner.ToggleHitbox(false)
	
	owner.SndSpinCharge.stop()


func Update(_delta: float) -> void:
	var horizVel = owner.velocity * Vector3(1, 0, 1)
	horizVel = lerp(horizVel, Vector3.ZERO, _delta)
	
	owner.SetVelocity(horizVel)
	
	if owner.Speed > owner.PARAMETERS.MOVE_MAX_SPEED:
		owner.SetVelocity(horizVel.normalized() * owner.PARAMETERS.MOVE_MAX_SPEED)
	
	owner.Move(horizVel + (Vector3.UP * VerticalVelocity))
	
	if owner.global_position.distance_to(LastFramePosition) < LASTFRAMEPOS_DIST_MAX:
		LastFramePositionCount += _delta
	else:
		LastFramePositionCount = 0.0
	
	LastFramePosition = owner.global_position
	
	
	var VerticalModifier := 0.5
	var collision : SonicCollision = owner.CollisionDetection(owner.PARAMETERS.LAND_FLOOR_DOT_MIN, owner.PARAMETERS.LAND_WALL_DOT_MIN)
	if collision != null:
		if collision.CollisionType == SonicCollision.COLL_TYPE.BOTTOM:
			if !IsOnFloor:
				print("Ball: Hit Ground")
				IsOnFloor = true
				
			owner.FloorNormal = collision.CollisionNormal #owner.get_floor_normal()
			owner.up_direction = owner.FloorNormal
			owner.GroundCast.target_position = -owner.FloorNormal.normalized() * owner.GroundCastLength
			
			var Dot = owner.FloorNormal.dot(Vector3.DOWN)
			if Dot < -0.99:
				if owner.Speed < 1.0:
					ChangeState("Idle")
					return
				else:
					VerticalVelocity = 0.01
					VerticalModifier = 0.0
			else:
				VerticalModifier = (Dot + 1.0) * 0.5
		elif collision.CollisionType == SonicCollision.COLL_TYPE.SIDE:
			var wallDot = owner.velocity.normalized().dot(collision.CollisionNormal)
			print("Ball: Slammed into wall, dot: " + str(wallDot))
			ChangeState("Idle")
			return
		else: #Handle ceiling hits
			pass
	else:
		owner.GroundCast.target_position = Vector3.DOWN * owner.GroundCastLength
		if IsOnFloor:
			print("Ball: Left Ground")
			IsOnFloor = false
	
	#print(VerticalModifier)
	VerticalVelocity -= owner.PARAMETERS.GRAVITY * _delta * (VerticalModifier if IsOnFloor else 1.0)

	if LastFramePositionCount > LASTFRAMEPOSCOUNT_MAX:
		ChangeState("Idle")
	


func AttackHit(Target: Hurtbox):
	if !owner.is_on_floor():
		VerticalVelocity = 1.0
	owner.DashModeCharge += 0.2
	Target.ReceiveDamage(owner.HitBox, 1)
