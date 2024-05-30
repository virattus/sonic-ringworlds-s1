extends BasicState


var VerticalVelocity := 0.0
var HorizVelocity := Vector3.ZERO

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
	
	#owner.floor_max_angle = owner.PARAMETERS.WALL_ANGLE_BALL
	
	owner.SndSpinCharge.play()
	
	if _msg.has("VerticalVelocity"):
		VerticalVelocity = _msg["VerticalVelocity"]
	else:
		VerticalVelocity = owner.velocity.y
	
	HorizVelocity = owner.velocity * Vector3(1, 0, 1)
	
	LastFramePosition = owner.global_position
	LastFramePositionCount = 0
	


func Exit() -> void:
	#owner.CharMesh.LookAt(owner.velocity.normalized())
	owner.SonicModel.visible = true
	owner.SonicBall.visible = false
	owner.ToggleHitbox(false)
	owner.DamageThreshold = owner.PARAMETERS.DAMAGE_THRESHOLD_NORMAL
	
	#owner.floor_max_angle = owner.PARAMETERS.WALL_ANGLE_NORMAL
	
	owner.SndSpinCharge.stop()


func Update(_delta: float) -> void:
	owner.Move(HorizVelocity + (Vector3.UP * VerticalVelocity))
	
	var newVel = owner.velocity
	
	HorizVelocity = newVel * Vector3(1, 0, 1)
	VerticalVelocity = newVel.y
	
	if HorizVelocity.length() > owner.PARAMETERS.BALL_HORIZ_MAX_SPEED:
		HorizVelocity.lerp(HorizVelocity.normalized() * owner.PARAMETERS.BALL_HORIZ_MAX_SPEED, owner.PARAMETERS.BALL_HORIZ_SPEED_LERP_MOD * _delta)
	
	if owner.GroundCollision:
		var InputVel = owner.Controller.InputVelocity
		var LerpSpeed = (clamp(-InputVel.dot(HorizVelocity.normalized()), 0.0, 1.0) * owner.PARAMETERS.BALL_LERP_MAGNITUDE) + owner.PARAMETERS.BALL_LERP_BASE
		HorizVelocity = HorizVelocity.move_toward(Vector3.ZERO, LerpSpeed * _delta)
	
	if owner.global_position.distance_to(LastFramePosition) < LASTFRAMEPOS_DIST_MAX:
		LastFramePositionCount += _delta
	else:
		LastFramePositionCount = 0.0
	
	LastFramePosition = owner.global_position
	
	
	owner.up_direction = owner.up_direction.normalized().slerp(owner.FloorNormal.normalized(), _delta * owner.UP_VEC_LERP_RATE)
	
	var VerticalModifier := 1.0
	
	if owner.is_on_floor():
		owner.FloorNormal = owner.get_floor_normal()
		owner.GroundCast.target_position = -owner.FloorNormal.normalized() * owner.GroundCastLength
		if owner.GroundCollision == false:
			print("Ball: Hit Ground")
			owner.GroundCollision = true
		if owner.FloorNormal.dot(Vector3.UP) > 0.75:
			VerticalVelocity = 0.0
	elif owner.is_on_wall():
		print("Ball: Hit wall")
		pass
	elif owner.is_on_ceiling(): #Hit ceiling
		print("Ball: Hit Ceiling")
		pass
	else:
		if owner.GroundCollision == true:
			owner.CharGroundCast.target_position = owner.FloorNormal * -2.0
			owner.CharGroundCast.force_raycast_update()
			if owner.CharGroundCast.is_colliding():
				if owner.global_position.distance_to(owner.CharGroundCast.get_collision_point()) < owner.PARAMETERS.MOVE_RAYCAST_SNAP_MAX_DISTANCE:
					var castDot = owner.CharGroundCast.get_collision_normal().dot(owner.FloorNormal)
					if castDot > 0.0:
						print("Ball: CharCast found ground")
						#owner.FloorNormal = owner.CharGroundCast.get_collision_normal()
						owner.global_position = owner.CharGroundCast.get_collision_point() + (owner.CharGroundCast.get_collision_normal() * 0.5)
				else:
					print("Ball: Too far for even CharCast: %s" % owner.global_position.distance_to(owner.CharGroundCast.get_collision_point()))
					owner.GroundCollision = false
					VerticalVelocity = 0.1
			else:
				print("Ball: Left ground")
				owner.GroundCollision = false
				VerticalVelocity = 0.1
	
	#print(VerticalModifier)
	VerticalVelocity -= owner.PARAMETERS.GRAVITY * _delta * (VerticalModifier if owner.GroundCollision else 1.0)
	if owner.PARAMETERS.FALL_TERMINAL_VEL > VerticalVelocity:
		VerticalVelocity = owner.PARAMETERS.FALL_TERMINAL_VEL

	if LastFramePositionCount > LASTFRAMEPOSCOUNT_MAX:
		UncurlAndIdle()
		return
	
	if owner.GroundCollision and owner.Speed < 1.0 and owner.FloorNormal.dot(Vector3.UP) > 0.75:
		UncurlAndIdle()
		return
	


func AttackHit(_Target: Hurtbox) -> void:
	print("Ball: Hit enemy")
	if !owner.is_on_floor():
		VerticalVelocity = owner.PARAMETERS.ATTACK_BOUNCE_POW
	owner.DashModeCharge += 0.2


func UncurlAndIdle() -> void:
	owner.CharMesh.look_at(owner.global_position + owner.velocity)
	owner.CharMesh.AlignToY(owner.up_direction)
	ChangeState("Idle")


func AlignToY(newY: Vector3) -> Basis:
	var newBasis = Basis.IDENTITY
	newBasis.y = newY
	newBasis.x = -newBasis.z.cross(newBasis.y)
	newBasis = newBasis.orthonormalized()
	return newBasis
	
