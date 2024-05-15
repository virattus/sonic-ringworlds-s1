extends BasicState


var VerticalVelocity := 0.0
var HorizVelocity := Vector3.ZERO

var IsOnFloor := true

var LastFramePosition := Vector3.ZERO
var LastFramePositionCount := 0.0


const LASTFRAMEPOS_DIST_MAX = 0.05
const LASTFRAMEPOSCOUNT_MAX = 1.0


func _ready() -> void:
	DebugMenu.AddMonitor(self, "HorizVelocity")
	DebugMenu.AddMonitor(self, "VerticalVelocity")
	DebugMenu.AddMonitor(self, "LastFramePosition")
	DebugMenu.AddMonitor(self, "LastFramePositionCount")


func Enter(_msg := {}) -> void:
	owner.SonicModel.visible = false
	owner.SonicBall.visible = true
	owner.ToggleHitbox(true)
	owner.DamageThreshold = owner.PARAMETERS.DAMAGE_THRESHOLD_BALL
	
	owner.SndSpinCharge.play()
	
	if _msg.has("VerticalVelocity"):
		VerticalVelocity = _msg["VerticalVelocity"]
	else:
		VerticalVelocity = owner.velocity.y
	
	HorizVelocity = owner.velocity * Vector3(1, 0, 1)
	
	LastFramePosition = owner.global_position
	LastFramePositionCount = 0
	
	IsOnFloor = owner.is_on_floor()
	


func Exit() -> void:
	#owner.CharMesh.LookAt(owner.velocity.normalized())
	owner.SonicModel.visible = true
	owner.SonicBall.visible = false
	owner.ToggleHitbox(false)
	owner.DamageThreshold = owner.PARAMETERS.DAMAGE_THRESHOLD_NORMAL
	
	owner.SndSpinCharge.stop()


func Update(_delta: float) -> void:
	owner.Move(HorizVelocity + (Vector3.UP * VerticalVelocity))
	
	HorizVelocity = owner.velocity * Vector3(1, 0, 1)
	
	if HorizVelocity.length() > owner.PARAMETERS.BALL_HORIZ_MAX_SPEED:
		HorizVelocity.lerp(HorizVelocity.normalized() * owner.PARAMETERS.BALL_HORIZ_MAX_SPEED, owner.PARAMETERS.BALL_HORIZ_SPEED_LERP_MOD * _delta)
	
	if IsOnFloor:
		var InputVel = owner.Controller.InputVelocity
		var LerpSpeed = (clamp(-InputVel.dot(HorizVelocity.normalized()), 0.0, 1.0) * owner.PARAMETERS.BALL_LERP_MAGNITUDE) + owner.PARAMETERS.BALL_LERP_BASE
		HorizVelocity = HorizVelocity.move_toward(Vector3.ZERO, LerpSpeed * _delta)
	
	if owner.global_position.distance_to(LastFramePosition) < LASTFRAMEPOS_DIST_MAX:
		LastFramePositionCount += _delta
	else:
		LastFramePositionCount = 0.0
	
	LastFramePosition = owner.global_position
	
	
	var VerticalModifier := 0.5
	var collision : SonicCollision = owner.CollisionDetection(owner.PARAMETERS.LAND_FLOOR_DOT_MIN, owner.PARAMETERS.LAND_WALL_DOT_MIN, !IsOnFloor)
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
					VerticalVelocity = 0.0
					VerticalModifier = 0.0
			else:
				VerticalModifier = (Dot + 1.0) * 0.5
		elif collision.CollisionType == SonicCollision.COLL_TYPE.SIDE:
			var AirDot = collision.CollisionNormal.dot(Vector3.UP)
			if AirDot > 0.5: 
				#
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
			VerticalVelocity = 0.01
	
	#print(VerticalModifier)
	VerticalVelocity -= owner.PARAMETERS.GRAVITY * _delta# * (VerticalModifier if IsOnFloor else 1.0)
	if VerticalVelocity < owner.PARAMETERS.FALL_TERMINAL_VEL:
		VerticalVelocity = owner.PARAMETERS.FALL_TERMINAL_VEL

	if LastFramePositionCount > LASTFRAMEPOSCOUNT_MAX:
		ChangeState("Idle")
	


func AttackHit(Target: Hurtbox):
	print("Ball: Hit enemy")
	if !owner.is_on_floor():
		VerticalVelocity = owner.PARAMETERS.ATTACK_BOUNCE_POW
	owner.DashModeCharge += 0.2
