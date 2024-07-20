extends Character


@export var Camera: ThirdPersonCamera

var DebugMove := false

var FloorNormal := Vector3.UP
var GroundPoint := Vector3.ZERO

var DashMode := false
var DashModeCharge := 0.0
var DashModeDrain := true

var Invincible := false
var Flicker := false
var DamageThreshold := 0

var DroppedRingSpeed := 1.0


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
@onready var HitBox = $Hitbox
@onready var LockOnArea = $LockOnArea


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



const GROUND_CAST_DIST = 0.1

const UP_VEC_LERP_RATE = 10.0


const PARAMETERS = preload("res://entities/Sonic/Sonic_Parameters.gd")

const COLLISION_INDICATOR = preload("res://entities/Collision/Collision.tscn")


func _ready() -> void:
	super()
	
	DebugMenu.AddMonitor(self, "up_direction")
	DebugMenu.AddMonitor(self, "FloorNormal")
	DebugMenu.AddMonitor(self, "GroundPoint")
	DebugMenu.AddMonitor(self, "DamageThreshold")
	DebugMenu.AddMonitor(self, "DashMode")
	DebugMenu.AddMonitor(self, "DashModeCharge")
	DebugMenu.AddMonitor(self, "DashModeDrain")
	DebugMenu.AddMonitor(self, "DroppedRingSpeed")
	
	


func _process(delta: float) -> void:
	#super(delta)
	
	if Input.is_action_just_pressed("DEBUG_DebugMove"):
		DebugMove = !DebugMove
		
		if DebugMove:
			StateM.ChangeState("DebugMove", {})
		else:
			StateM.ChangeState("Fall", {
			})
	
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

	if Flicker:
		CharMesh.visible = (fmod(round(TimerInvincibility.time_left / PARAMETERS.FLICKER_TIME), 2.0) == 0)
	
	#Update debug indicators
	UpVectorIndicator.position = up_direction
	FloorNormalIndicator.position = FloorNormal
	
	if GetInputVector().length() > 0.0:
		InputIndicator.look_at(global_position - GetInputVector().normalized())
		
	if velocity.length() > 0.0:
		VelocityIndicator.transform = VelocityIndicator.transform.looking_at(VelocityIndicator.position + (VelocityIndicator.position - velocity.normalized()) + Vector3(0.0001, 0.0001, 0.0001))


func Move() -> void:
	super()
	UpdateUpDirection()


func UpdateUpDirection() -> void:
	pass


func CollisionDetection(groundMin: float, wallMin: float) -> bool:
	return true


func GetInputVector() -> Vector3:
	var CameraForward = Camera.GetCameraBasis().z
	var CameraRight = Camera.GetCameraBasis().x
	
	var newInput = (CameraForward * Controller.InputAnalogue.y) + (CameraRight * Controller.InputAnalogue.x)
	var newVelocity = (Quaternion(Vector3.UP, up_direction)) * newInput
	
	return newVelocity


func IsInputSkidding() -> bool:
	if Controller.InputVelocity.length() > PARAMETERS.SKID_INPUT_MIN:
		var InputDir = velocity.normalized().dot(Controller.InputVelocity.normalized())
		if InputDir < PARAMETERS.SKID_ANGLE_MIN:
			print("Land: Skid ratio: %s" % InputDir)
			return true
		
	return false


func CollectRing() -> bool:
	if Globals.RingCount < 100:
		$SndRingCollect.play()
		DashModeCharge += PARAMETERS.DASHMODE_RING_INCREMENT
		Globals.RingCount += 1
		return true
	return false


func CollectOneUp() -> bool:
	$SndOneUp.play()
	DroppedRingSpeed = 1.0
	Globals.LivesCount += 1
	return true


func _on_timer_invincibility_timeout() -> void:
	Invincible = false
	Flicker = false
	CharMesh.visible = true


func ToggleHitbox(enabled: bool) -> void:
	HitBox.monitoring = enabled
	$Hitbox/AttackAreaDebug.visible = enabled


func _on_hitbox_hitbox_activated(Target: Hurtbox) -> void:
	if StateM.ActiveState.has_method("AttackHit"):
		StateM.ActiveState.AttackHit(Target)


func _on_hurtbox_hurtbox_activated(Source: Hitbox, Damage: int) -> void:
	if !Invincible:
		if Damage > DamageThreshold:
			if Globals.RingCount > 0:
				StateM.ChangeState("Hurt", {
					"BounceDirection": Source.global_position.direction_to(global_position).normalized() * Vector3(3, 0, 3),
					"DropRings": true,
				})
			else:
				StateM.ChangeState("Death")
