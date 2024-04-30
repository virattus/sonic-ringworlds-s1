extends Character



@export var Camera: ThirdPersonCamera

var FloorNormal := Vector3.UP
var GroundPoint := Vector3.ZERO

var DashMode := false
var DashModeCharge := 0.0
var DashModeDrain := true
var Invincible := false
var Flicker := false

const GROUND_CAST_DIST = 0.1

const UP_VEC_LERP_RATE = 10.0


const PARAMETERS = preload("res://entities/Sonic/Sonic_Parameters.gd")

@onready var SonicModel = $CharacterMesh/SonicModel
@onready var SonicBall = $CharacterMesh/SonicBall

@onready var CharGroundCast = $AngledGroundCast
@onready var AnimTree: AnimationTree = $AnimationTree
@onready var StateM: StateMachine = $StateMachine
@onready var TimerInvincibility = $TimerInvincibility
@onready var AirdashTrail = $CylinderTrail2

@onready var UpVectorIndicator = $UpVectorIndicator/UpVectorOrb
@onready var FloorNormalIndicator = $FloorNormalIndicator
@onready var InputIndicator = $InputIndicator
@onready var VelocityIndicator = $VelocityIndicator
@onready var CameraFocus = $CameraFocus
@onready var AttackArea = $AttackArea
@onready var TargetArea = $TargetArea


@onready var SndJump = $SndJump
@onready var SndAirdash = $SndAirdash
@onready var SndLand = $SndLand
@onready var SndBonk = $SndBonk
@onready var SndSkid = $SndSkid
@onready var SndRingCollect = $SndRingCollect
@onready var SndRingDrop = $SndRingDrop
@onready var SndDeath = $SndDeath
@onready var SndSpinCharge = $SndSpinCharge
@onready var SndSpinLaunch = $SndSpinLaunch


@onready var StartingPosition := global_position
@onready var CollisionSize: float = $WorldCollision.shape.radius #lol redo this
@onready var CharGroundCastLength := 2.0
@onready var GroundCastLength := 25.0


func _ready() -> void:
	super()
	
	DebugMenu.AddMonitor(self, "up_direction")
	DebugMenu.AddMonitor(self, "FloorNormal")
	DebugMenu.AddMonitor(self, "GroundPoint")
	
	


func _process(delta: float) -> void:
	#super(delta)
	
	if Globals.DEBUG_FORCE_DASHMODE:
		DashMode = true
	else:
		if DashModeDrain:
			if DashMode:
				DashModeCharge -= (PARAMETERS.DASHMODE_ACTIVE_DISCHARGE_RATE * delta)
				if DashModeCharge <= 0.0:
					DashMode = false
			else:
				DashModeCharge -= (PARAMETERS.DASHMODE_NORMAL_DISCHARGE_RATE * delta)
		
		DashModeCharge = clamp(DashModeCharge, PARAMETERS.DASHMODE_MIN_CHARGE, PARAMETERS.DASHMODE_MAX_CHARGE)
	
	if Input.is_action_just_pressed("DEBUG_ResetPosition"):
		global_position = StartingPosition
		Speed = 0.0
		velocity = Vector3.ZERO
		up_direction = Vector3.UP
		FloorNormal = Vector3.UP
		StateM.ChangeState("Idle")

	if Flicker:
		CharMesh.visible = (fmod(round(TimerInvincibility.time_left / PARAMETERS.FLICKER_TIME), 2.0) == 0)

	
	#up_direction = up_direction.slerp(FloorNormal.normalized(), delta * UP_VEC_LERP_RATE).normalized()
	#up_direction = FloorNormal
	
	
	UpVectorIndicator.position = up_direction
	FloorNormalIndicator.position = FloorNormal
	if Controller.InputVelocity.length() > 0.0:
		InputIndicator.look_at(global_position - Controller.InputVelocity.normalized())
		
	if velocity.length() > 0.0:
		VelocityIndicator.transform = VelocityIndicator.transform.looking_at(VelocityIndicator.position + (VelocityIndicator.position - velocity.normalized()))
	


func Move(newVelocity: Vector3) -> void:
	super(newVelocity)


func UpdateUpDir() -> void:
	if is_on_floor():
		FloorNormal = get_floor_normal()
	#else:
	#	FloorNormal = Vector3.UP


func CheckCharGroundCast() -> bool:
	#CharGroundCast.target_position = -(FloorNormal.normalized())
	CharGroundCast.force_raycast_update()
	if CharGroundCast.is_colliding():
		GroundPoint = CharGroundCast.get_collision_point()
		if global_position.distance_to(GroundPoint) <= CollisionSize + GROUND_CAST_DIST:
			return true
		else:
			return false
	else:
		return false


func CheckFixedGroundCast() -> bool:
	GroundCast.force_raycast_update()
	if GroundCast.is_colliding():
		var Point = GroundCast.get_collision_point()
		if global_position.distance_to(Point) <= CollisionSize + GROUND_CAST_DIST:
			GroundPoint = Point
			FloorNormal = GroundCast.get_collision_normal()
			#print("%s to %s" % [global_position, GroundPoint])
			return true
		else:
			return false
	else:
		return false


func CheckGroundCollision() -> bool:
	if is_on_floor():
		GroundCollision = true
	#elif global_position.distance_to(GroundPoint) <= CollisionSize + GROUND_CAST_DIST:
	#	return true
	else:
		if CheckCharGroundCast():
			GroundCollision = true
		else:
			GroundCollision = false
	
	return GroundCollision


func ReceiveDamage(hurtbox: Area3D, damage: int) -> void:
	if !Invincible:
		if Globals.RingCount > 0:
			StateM.ChangeState("Hurt", {
				"BounceDirection": hurtbox.global_position.direction_to(global_position).normalized() * Vector3(3, 0, 3),
				"DropRings": true,
			})
		else:
			HealthEmpty.emit()
			StateM.ChangeState("Death")


func CollectRing() -> void:
	DashModeCharge += PARAMETERS.DASHMODE_RING_INCREMENT
	$SndRingCollect.play()


func _on_timer_invincibility_timeout() -> void:
	Invincible = false
	Flicker = false
	CharMesh.visible = true


func _on_attack_area_body_entered(body: Node3D) -> void:
	if StateM.ActiveState.has_method("AttackHit"):
		StateM.ActiveState.AttackHit(body)


func ToggleAttackArea(enabled: bool) -> void:
	AttackArea.monitoring = enabled
	$AttackArea/AttackAreaDebug.visible = enabled
