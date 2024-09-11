class_name Player
extends Character


enum ShieldState {
	NONE,
	NORMAL_SHIELD,
	FIRE_SHIELD,
	WATER_SHIELD,
	THUNDER_SHIELD,
}


@export var Camera: ThirdPersonCamera

var DebugMove := false
var DebugMoveVector := Vector3.ZERO
var DebugFloorNormal := Vector3.ZERO
var DebugCollisionPos := Vector3.ZERO
var DebugCollisionPositionDeviation := Vector3.ZERO
var DebugCollisionNormal := Vector3.ZERO
var DebugCollisionNormalDeviation := Vector3.ZERO

var CurrentGravity := 1.0
var StickToFloor := true
var AlignToSurface := true

var CanCollectRings := true
var HasJumped := false
var CanHang := false

var RunOnWater := false
var IsUnderwater := false
var Oxygen := 1.0

var CurrentShieldState := ShieldState.NONE
var CurrentShield = null

var DashMode := false
var DashModeCharge := 0.0
var DashModeDrain := true

var Invincible := false
var Flicker := false
var DamageThreshold := 0

var DroppedRingSpeed := 1.0




@onready var SonicModel = $CharacterMesh/SonicModel
@onready var SonicBall = $CharacterMesh/SonicBall

@onready var AnimTree: AnimationTree = $AnimationTree
@onready var StateM: StateMachine = $StateMachine
@onready var AirdashTrail = $CylinderTrail2
@onready var CollisionCast : RayCast3D = $CollisionCast
@onready var WaterSurfaceCast : RayCast3D = $WaterSurfaceCast

@onready var UpVectorIndicator = $UpVectorIndicator/UpVectorOrb
@onready var FloorNormalIndicator = $FloorNormalIndicator
@onready var InputIndicator = $InputIndicator
@onready var VelocityIndicator = $VelocityIndicator
@onready var CameraFocus = $CameraFocus
@onready var HitBox : Hitbox = $Hitbox
@onready var LockOnArea = $LockOnArea

@onready var TimerInvincibility = $TimerInvincibility
@onready var TimerFlicker = $TimerFlicker

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
@onready var SndOneUp = $SndOneUp
@onready var SndShieldActive = $SndShieldActive
@onready var SndWaterRunFootstep = $SndWaterRunFootstep
@onready var SndWaterBreathe = $SndWaterBreathe


@onready var StartingPosition := global_position


const COLLISION_CAST_LENGTH = 1.0

const OXYGEN_DRAIN_RATE = 0.0333


const PARAMETERS = preload("res://entities/Sonic/Sonic_Parameters.gd")

const COLLISION_INDICATOR = preload("res://entities/Collision/Collision.tscn")
const SMOKE = preload("res://effects/Smoke/Smoke.tscn")

const NORMAL_SHIELD = preload("res://effects/Shield/NormalShield.tscn")
const FIRE_SHIELD = preload("res://effects/Shield/FireShield.tscn")
const THUNDER_SHIELD = preload("res://effects/Shield/ThunderShield.tscn")
const WATER_SHIELD = preload("res://effects/Shield/WaterShield.tscn")



func _ready() -> void:
	super()
	
	CurrentGravity = PARAMETERS.GRAVITY
	
	DebugMenu.AddMonitor(self, "DebugMove")
	DebugMenu.AddMonitor(self, "DebugMoveVector")
	DebugMenu.AddMonitor(self, "DebugFloorNormal")
	DebugMenu.AddMonitor(self, "DebugCollisionPositionDeviation")
	DebugMenu.AddMonitor(self, "DebugCollisionNormalDeviation")
	DebugMenu.AddMonitor(self, "up_direction")
	DebugMenu.AddMonitor(self, "CurrentGravity")
	DebugMenu.AddMonitor(self, "StickToFloor")
	DebugMenu.AddMonitor(self, "AlignToSurface")
	DebugMenu.AddMonitor(self, "CanCollectRings")
	DebugMenu.AddMonitor(self, "HasJumped")
	DebugMenu.AddMonitor(self, "RunOnWater")
	DebugMenu.AddMonitor(self, "IsUnderwater")
	DebugMenu.AddMonitor(self, "Oxygen")
	DebugMenu.AddMonitor(self, "Invincible")
	DebugMenu.AddMonitor(self, "DashMode")
	DebugMenu.AddMonitor(self, "DashModeCharge")
	DebugMenu.AddMonitor(self, "DashModeDrain")
	DebugMenu.AddMonitor(self, "DamageThreshold")
	DebugMenu.AddMonitor(self, "DroppedRingSpeed")



func _process(delta: float) -> void:
	if Input.is_action_just_pressed("DEBUG_DebugMove"):
		DebugMove = !DebugMove
		
		if DebugMove:
			StateM.ChangeState("DebugMove", {})
		else:
			StateM.ChangeState("Fall", {})
	
	UpdateDebugIndicators(DebugMoveVector, DebugFloorNormal)
	
	#hacky, but whatever
	if IsUnderwater:
		if Oxygen <= 0.0:
			if StateM.CurrentState != "Death":
				StateM.ChangeState("Death", {})
				return
			
		Oxygen -= delta * OXYGEN_DRAIN_RATE
	else:
		Oxygen = 1.0
		
	
	if DashModeDrain:
		if DashMode:
			DashModeCharge -= (PARAMETERS.DASHMODE_DISCHARGE_RATE * delta)
			if DashModeCharge <= 0.0:
				SetDashMode(false)
		else:
			DashModeCharge -= (PARAMETERS.DASHMODE_SLOW_DISCHARGE_RATE * delta)
		
		DashModeCharge = clamp(DashModeCharge, PARAMETERS.DASHMODE_MIN_CHARGE, PARAMETERS.DASHMODE_MAX_CHARGE)
	
	if Globals.DEBUG_FORCE_DASHMODE:
		DashMode = true
		DashModeCharge = 100.0
	
	if Flicker:
		CharMesh.visible = (fmod(round(TimerFlicker.time_left / PARAMETERS.FLICKER_CYCLE_TIME), 2.0) == 0)


func GetCollision() -> SonicCollision:
	var collision = get_last_slide_collision()
	if collision:
		DebugCollisionPos = collision.get_position()
		DebugCollisionNormal = collision.get_normal()
	
	if is_on_floor():
		DebugFloorNormal = get_floor_normal()
		DebugCollisionNormalDeviation = DebugFloorNormal - DebugCollisionNormal
		return SonicCollision.new(SonicCollision.FLOOR, get_floor_normal())
	elif is_on_wall():
		DebugFloorNormal = get_wall_normal()
		DebugCollisionNormalDeviation = DebugFloorNormal - DebugCollisionNormal
		return SonicCollision.new(SonicCollision.WALL, get_wall_normal())
	elif is_on_ceiling():
		DebugCollisionNormalDeviation = Vector3.ZERO
		return SonicCollision.new(SonicCollision.CEILING, DebugCollisionNormal) #Can't get ceiling normal
	else:
		return SonicCollision.new(SonicCollision.NONE)


func ApplyGravity(vel: Vector3, delta: float) -> Vector3:
	var gravity = CurrentGravity
	if IsUnderwater:
		gravity = CurrentGravity / 4.0
	
	return vel - Vector3.UP * (gravity * delta)


func ApplyDrag(vel: Vector3, delta: float) -> Vector3:
	return lerp(vel, Vector3.ZERO, delta)


func UpdateUpDir(floor_normal: Vector3, delta: float) -> void:
	up_direction = floor_normal
	
	CollisionCast.target_position = -up_direction * COLLISION_CAST_LENGTH
	
	if delta > 0.0 and floor_normal.is_normalized():
		up_direction = up_direction.slerp(floor_normal, PARAMETERS.UPDIR_SLERP_RATE * delta)



func GetInputVector(up_dir: Vector3) -> Vector3:
	var playerInput = Input.get_vector("Move_Left", "Move_Right", "Move_Forward", "Move_Backward", 0.4)
	
	var CameraForward = Camera.global_transform.basis.z
	var CameraRight = Camera.global_transform.basis.x
	
	var newInput = (CameraForward * playerInput.y) + (CameraRight * playerInput.x)
	var newVelocity = (Quaternion(Vector3.UP, up_dir).normalized()) * newInput

	DebugMoveVector = newVelocity

	return newVelocity


func CollectRing(ringCount := 1) -> bool:
	if !CanCollectRings:
		return false
	
	if Globals.RingCount < 100:
		$SndRingCollect.play()
		DashModeCharge += PARAMETERS.DASHMODE_INCREMENT_RING
		Globals.RingCount += ringCount
		return true
	
	return false


func CollectOneUp() -> bool:
	$SndOneUp.play()
	DroppedRingSpeed = 1.0
	Globals.LivesCount += 1
	return true


func SetRunOnWater(Active: bool) -> void:
	RunOnWater = Active
	set_collision_mask_value(13, Active)


func SetUnderwater(Active: bool) -> void:
	IsUnderwater = Active
	Oxygen = 1.0


func IsOnWaterSurface() -> bool:
	return WaterSurfaceCast.is_colliding()


func BreatheAirBubble() -> void:
	Oxygen = 1.0
	SndWaterBreathe.play()
	velocity = Vector3.ZERO
	StateM.ChangeState("Fall")


func SetInvincible(Active: bool) -> void:
	pass


func SetShieldState(newState: ShieldState) -> void:	
	if CurrentShieldState != ShieldState.NONE:
		CurrentShield.queue_free()
		CurrentShield = null
	
	CurrentShieldState = newState

	
	match newState:
		ShieldState.NORMAL_SHIELD:
			CurrentShield = NORMAL_SHIELD.instantiate()
		ShieldState.FIRE_SHIELD:
			CurrentShield = FIRE_SHIELD.instantiate()
		ShieldState.WATER_SHIELD:
			CurrentShield = WATER_SHIELD.instantiate()
		ShieldState.THUNDER_SHIELD:
			CurrentShield = THUNDER_SHIELD.instantiate()
	
	add_child(CurrentShield)



func SetDashMode(Active: bool) -> void:
	DashMode = Active
	DashModeDrain = Active
	SetAfterimageOrb(Active)
	
	if Active:
		ActivateHitbox(true)
		DamageThreshold = PARAMETERS.DAMAGE_THRESHOLD_STRIKEDASH
	else:
		ActivateHitbox(false)
		DamageThreshold = PARAMETERS.DAMAGE_THRESHOLD_NORMAL


func SetAfterimageOrb(Active: bool) -> void:
	$CharacterMesh/SonicModel/Armature/Skeleton3D/BoneAttachBody/AfterimageOrbEmitter.Active = Active
	$CharacterMesh/SonicModel/Armature/Skeleton3D/BoneAttachFootL/AfterimageOrbEmitter.Active = Active
	$CharacterMesh/SonicModel/Armature/Skeleton3D/BoneAttachFootR/AfterimageOrbEmitter.Active = Active
	$CharacterMesh/SonicModel/Armature/Skeleton3D/BoneAttachHandL/AfterimageOrbEmitter.Active = Active
	$CharacterMesh/SonicModel/Armature/Skeleton3D/BoneAttachHandR/AfterimageOrbEmitter.Active = Active


func OrientCharMesh() -> void:
	CharMesh.look_at(global_position + velocity)


func AlignToY(newY: Vector3) -> Basis:
	var newBasis = Basis.IDENTITY
	newBasis.y = newY
	newBasis.x = -newBasis.z.cross(newBasis.y)
	newBasis = newBasis.orthonormalized()
	return newBasis


func UpdateDebugIndicators(new_input_vector: Vector3, new_floor_normal: Vector3) -> void:
	UpVectorIndicator.position = up_direction
	FloorNormalIndicator.position = -CollisionCast.target_position.normalized()
	
	if new_input_vector.length() > 0.0:
		InputIndicator.scale = Vector3.ONE
		if new_input_vector != Vector3.UP:
			InputIndicator.look_at(global_position - new_input_vector.normalized())
	else:
		InputIndicator.scale = Vector3.ZERO
		
	if velocity.length() > 0.0:
		VelocityIndicator.transform = VelocityIndicator.transform.looking_at(VelocityIndicator.position + (VelocityIndicator.position - velocity.normalized()) + Vector3(0.0001, 0.0001, 0.0001))


func CreateCollisionIndicator(point: Vector3, normal: Vector3) -> void:
	var collInd = COLLISION_INDICATOR.instantiate()
	get_parent().add_child(collInd)
	collInd.SetToVectors(point, normal)


func CreateSmoke() -> void:
	var newSmoke = SMOKE.instantiate()
	get_parent().add_child(newSmoke)
	newSmoke.global_position = global_position


func _on_timer_invincibility_timeout() -> void:
	Invincible = false
	Flicker = false
	CharMesh.visible = true


func _on_timer_flicker_timeout() -> void:
	Flicker = false


func ActivateHitbox(Active: bool) -> void:
	HitBox.monitoring = Active
	$Hitbox/AttackAreaDebug.visible = Active
	#disable player collision with item boxes, so that the player can roll through them
	set_collision_mask_value(11, !Active)


func ActivateHurtbox(Active: bool) -> void:
	HurtBox.monitoring = Active


func AttackHit(Target: Hurtbox, ChargeValue = -1.0) -> void:
	if StateM.ActiveState.has_method("AttackHit"):
		StateM.ActiveState.AttackHit(Target)
		if ChargeValue >= 0.0:
			DashModeCharge += ChargeValue
		else:
			DashModeCharge += PARAMETERS.DASHMODE_INCREMENT_ENEMY




func _on_hitbox_hitbox_activated(Target: Hurtbox) -> void:
	AttackHit(Target)


func DamageReceived(SourcePos: Vector3, Damage: int) -> void:
	if Invincible or (Damage < DamageThreshold):
		return
	
	if CurrentShieldState != ShieldState.NONE:
		SetShieldState(ShieldState.NONE)
		StateM.ChangeState("Hurt", {
			"BounceDirection": SourcePos.direction_to(global_position).normalized() * Vector3(3, 0, 3),
			"DropRings": false,
		})
		return
	
	if Globals.RingCount > 0:
		StateM.ChangeState("Hurt", {
			"BounceDirection": SourcePos.direction_to(global_position).normalized() * Vector3(3, 0, 3),
			"DropRings": true,
		})
	else:
		StateM.ChangeState("Death")


func Kill() -> void:
	SetAfterimageOrb(false)
	SetShieldState(ShieldState.NONE)
	StateM.ChangeState("Death")


func _on_hurtbox_hurtbox_activated(Source: Hitbox, Damage: int) -> void:
	DamageReceived(Source.global_position, Damage)
