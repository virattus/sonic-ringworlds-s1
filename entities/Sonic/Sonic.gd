extends Character


signal Death


@export var Camera: ThirdPersonCamera

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
		StateM.ChangeState("Air", {
			"SubState": "Fall",
		})

	if Flicker:
		CharMesh.visible = (fmod(round(TimerInvincibility.time_left / PARAMETERS.FLICKER_TIME), 2.0) == 0)

	
	#up_direction = up_direction.slerp(FloorNormal.normalized(), delta * UP_VEC_LERP_RATE).normalized()
	#up_direction = FloorNormal
	
	
	UpVectorIndicator.position = up_direction
	FloorNormalIndicator.position = FloorNormal
	if Controller.InputVelocity.length() > 0.0:
		InputIndicator.look_at(global_position - Controller.InputVelocity.normalized())
		
	if velocity.length() > 0.0:
		VelocityIndicator.transform = VelocityIndicator.transform.looking_at(VelocityIndicator.position + (VelocityIndicator.position - velocity.normalized()) + Vector3(0.0001, 0.0001, 0.0001))
	


func Move(newVelocity: Vector3) -> void:
	super(newVelocity)


func CollisionDetection(groundMin: float, wallMin: float, debugInfo := false) -> SonicCollision:
	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		if debugInfo:
			var coll = COLLISION_INDICATOR.instantiate()
			get_parent().add_child(coll)
			coll.SetToCollision(collision)
		
		var dot = up_direction.dot(collision.get_normal())
		if dot > groundMin:
			if debugInfo:
				print("Collision: Floor hit")
			return SonicCollision.new(SonicCollision.COLL_TYPE.BOTTOM, collision.get_position(), collision.get_normal())
		elif dot > wallMin:
			if debugInfo:
				print("Collision: Side hit")
			return SonicCollision.new(SonicCollision.COLL_TYPE.SIDE, collision.get_position(), collision.get_normal())
		else: #Hit ceiling
			if debugInfo:
				print("Collision: Ceiling Hit")
			return SonicCollision.new(SonicCollision.COLL_TYPE.TOP, collision.get_position(), collision.get_normal())
	return null


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
