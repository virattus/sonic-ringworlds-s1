class_name Player
extends Character


signal PlayDrowningMusic(play: bool)


enum SHIELD {
	NONE,
	NORMAL_SHIELD,
	FIRE_SHIELD,
	WATER_SHIELD,
	THUNDER_SHIELD,
}

enum OXYGEN {
	NO_AIR_DRAIN,
	START_AIR_DRAIN,
	WARNING_CHIME_1,
	WARNING_CHIME_2,
	WARNING_CHIME_3,
	WARNING_BUBBLE_5,
	WARNING_BUBBLE_4,
	WARNING_BUBBLE_3,
	WARNING_BUBBLE_2,
	WARNING_BUBBLE_1,
	WARNING_BUBBLE_0,
	EMPTY,
}


@export var Camera: GameCamera
@export var Parameters: Resource

var DebugMove := false
var DebugMoveVector := Vector3.ZERO
var DebugFloorNormal := Vector3.ZERO
var DebugCollisionPos := Vector3.ZERO
var DebugCollisionPositionDeviation := Vector3.ZERO
var DebugCollisionNormal := Vector3.ZERO
var DebugCollisionNormalDeviation := Vector3.ZERO

var TrueVelocity := Vector3.ZERO
var BounceVelocity := Vector3.ZERO

var CurrentGravity := 1.0
var StickToFloor := true
var AlignToSurface := true

var CanCollectRings := true
var CanJump := false
var CanHang := false
var HangMovementAxis := Vector3.ZERO

var RunOnWater := false
var IsUnderwater := false
var OxygenState := OXYGEN.NO_AIR_DRAIN

var ShieldState := SHIELD.NONE
var CurrentShield = null

var DashMode := false
var DashModeCharge := 0.0
var DashModeDrain := true

var Flicker := false
var DamageThreshold := 0


@onready var PushCast : RayCast3D = $CharacterMesh/PushCast

@onready var AnimTree: AnimationTree = $AnimationTree
@onready var StateM: StateMachine = $StateMachine
@onready var AirdashTrail = $CylinderTrail2
@onready var CollisionCast : RayCast3D = $CollisionCast
@onready var WaterSurfaceCast : RayCast3D = $WaterSurfaceCast

@onready var UpVectorIndicator = $UpVectorIndicator/UpVectorOrb
@onready var FloorNormalIndicator = $FloorNormalIndicator
@onready var InputIndicator = $InputIndicator
@onready var VelocityIndicator = $VelocityIndicator
@onready var HitBox : Hitbox = $Hitbox
@onready var LockOnArea = $LockOnArea

@onready var TimerInvincibility = $TimerInvincibility
@onready var TimerFlicker = $TimerFlicker
@onready var TimerOxygen = $TimerOxygen

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
@onready var SndWaterDrown = $SndWaterDrown
@onready var SndOxygenChime = $SndOxygenChime


@onready var SpawnPosition := global_position
var WorldRadius := 0.5

const COLLISION_CAST_LENGTH = 1.0

const BOUNCE_REDUCTION_MOD = 2.5

const COLLISION_INDICATOR = preload("res://entities/Collision/Collision.tscn")
const SMOKE = preload("res://effects/Smoke/Smoke.tscn")

const NORMAL_SHIELD = preload("res://effects/Shield/NormalShield.tscn")
const FIRE_SHIELD = preload("res://effects/Shield/FireShield.tscn")
const THUNDER_SHIELD = preload("res://effects/Shield/ThunderShield.tscn")
const WATER_SHIELD = preload("res://effects/Shield/WaterShield.tscn")




func _ready() -> void:
	super()
	
	CurrentGravity = Parameters.GRAVITY
	
	DebugMenu.AddMonitor(self, "TrueVelocity")
	DebugMenu.AddMonitor(self, "BounceVelocity")
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
	DebugMenu.AddMonitor(self, "CanJump")
	DebugMenu.AddMonitor(self, "RunOnWater")
	DebugMenu.AddMonitor(self, "IsUnderwater")
	DebugMenu.AddMonitor(self, "OxygenState")
	DebugMenu.AddMonitor(self, "Invincible")
	DebugMenu.AddMonitor(self, "DashMode")
	DebugMenu.AddMonitor(self, "DashModeCharge")
	DebugMenu.AddMonitor(self, "DashModeDrain")
	DebugMenu.AddMonitor(self, "DamageThreshold")


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("DEBUG_DebugMove"):
		DebugMove = !DebugMove
		
		if DebugMove:
			StateM.ChangeState("DebugMove", {})
		else:
			StateM.ChangeState("Fall", {})
	
	if !BounceVelocity.is_zero_approx():
		BounceVelocity = BounceVelocity.move_toward(Vector3.ZERO, BOUNCE_REDUCTION_MOD * delta)
	
	UpdateDebugIndicators(DebugMoveVector, DebugFloorNormal)
	
	if DashModeDrain:
		if DashMode:
			DashModeCharge -= (Parameters.DASHMODE_DISCHARGE_RATE * delta)
			if DashModeCharge <= 0.0:
				SetDashMode(false)
		else:
			DashModeCharge -= (Parameters.DASHMODE_SLOW_DISCHARGE_RATE * delta)
		
		DashModeCharge = clamp(DashModeCharge, Parameters.DASHMODE_MIN_CHARGE, Parameters.DASHMODE_MAX_CHARGE)
	
	if Globals.DEBUG_FORCE_DASHMODE:
		DashMode = true
		DashModeCharge = 100.0
	
	if Flicker:
		CharMesh.visible = (fmod(round(TimerFlicker.time_left / Parameters.FLICKER_CYCLE_TIME), 2.0) == 0)


func Move() -> void:
	move_and_slide()


func GetCollision() -> CharCollision:
	var collision = get_last_slide_collision()
	if collision:
		DebugCollisionPos = collision.get_position()
		DebugCollisionNormal = collision.get_normal()
	
	if is_on_floor():
		DebugFloorNormal = get_floor_normal()
		DebugCollisionNormalDeviation = DebugFloorNormal - DebugCollisionNormal
		return CharCollision.new(CharCollision.FLOOR, get_floor_normal())
	elif is_on_wall():
		DebugFloorNormal = get_wall_normal()
		DebugCollisionNormalDeviation = DebugFloorNormal - DebugCollisionNormal
		return CharCollision.new(CharCollision.WALL, get_wall_normal())
	elif is_on_ceiling():
		DebugCollisionNormalDeviation = Vector3.ZERO
		return CharCollision.new(CharCollision.CEILING, DebugCollisionNormal) #Can't get ceiling normal
	else:
		return CharCollision.new(CharCollision.NONE)


func ApplyGravity(vel: Vector3, delta: float) -> Vector3:
	var gravity = CurrentGravity
	if IsUnderwater:
		gravity = CurrentGravity / 4.0
	
	return vel - Vector3.UP * (gravity * delta)


func ApplyDrag(vel: Vector3, delta: float) -> Vector3:
	return lerp(vel, Vector3.ZERO, delta)


func UpdateUpDir(floor_normal: Vector3, delta := -1.0) -> void:
	if delta > 0.0 and floor_normal.is_normalized():
		up_direction = up_direction.slerp(floor_normal.normalized(), Parameters.UPDIR_SLERP_RATE * delta).normalized()
	else:
		up_direction = floor_normal.normalized()
	
	CollisionCast.target_position = -up_direction * COLLISION_CAST_LENGTH


func SlipDir(CollisionNormal: Vector3) -> Vector3:
	var UpDirInverse : Vector3 = Vector3.ONE - up_direction
	return CollisionNormal - (UpDirInverse * UpDirInverse.dot(CollisionNormal))


func SetVelocity(newVelocity: Vector3) -> void:
	if newVelocity.length() > Parameters.MOVE_MAX_SPEED:
		newVelocity = newVelocity.normalized() * Parameters.MOVE_MAX_SPEED
	
	super(newVelocity)


func SetTrueVelocity(newVel: Vector3) -> void:
	if newVel.length() > Parameters.VEL_TRUE_CAP:
		newVel = newVel.normalized() * Parameters.VEL_TRUE_CAP
	
	TrueVelocity = newVel


func GetInputVector(up_dir: Vector3) -> Vector3:
	var playerInput = Input.get_vector("Move_Left", "Move_Right", "Move_Forward", "Move_Backward", 0.4)
	
	#var CameraForward = Camera.global_transform.basis.z
	#var CameraRight = Camera.global_transform.basis.x
	
	var CameraForward = (Camera.GetBasis().z * Vector3(1, 0, 1)).normalized()
	var CameraRight = (Camera.GetBasis().x * Vector3(1, 0, 1)).normalized()
	
	var newInput = (CameraForward * playerInput.y) + (CameraRight * playerInput.x)
	var newVelocity = (Quaternion(Vector3.UP, up_dir).normalized()) * newInput

	DebugMoveVector = newVelocity

	return newVelocity


func IsInputSkidding(input: Vector3) -> bool:
	var ForwardVector = CharMesh.GetForwardVector()
	var forwardDot = ForwardVector.dot(input.normalized())
	
	if forwardDot < Parameters.SKID_MAX_ANGLE:
		#print("Input skidding? %s" % forwardDot)
		return true
	
	return false


func SnapToGroundCast() -> void:
	GroundCast.force_raycast_update()
	global_position = GroundCast.get_collision_point() + (Vector3.UP * (WorldRadius / 2.0))


func SetDashMode(Active: bool) -> void:
	pass


func SetCollisionCastDir(newDir: Vector3) -> void:
	CollisionCast.target_position = newDir.normalized() * COLLISION_CAST_LENGTH


func CollectRing(ringCount := 1) -> bool:
	if !CanCollectRings:
		return false
	
	if Globals.RingCount < 100:
		$SndRingCollect.play()
		DashModeCharge += Parameters.DASHMODE_INCREMENT_RING
		Globals.RingCount += ringCount
		return true
	
	return false


func CollectOneUp() -> bool:
	$SndOneUp.play()
	Globals.DroppedRingSpeed = 1.0
	Globals.LivesCount += 1
	return true


func SetRunOnWater(Active: bool) -> void:
	RunOnWater = Active
	set_collision_mask_value(13, Active)


func SetUnderwater(Active: bool) -> void:
	IsUnderwater = Active
	
	if Active:
		OxygenState = OXYGEN.START_AIR_DRAIN
	else:
		OxygenState = OXYGEN.NO_AIR_DRAIN
	
	UpdateOxygenState()


func UpdateOxygenState() -> void:
	match OxygenState:
		OXYGEN.NO_AIR_DRAIN:
			TimerOxygen.stop()
			PlayDrowningMusic.emit(false)
		OXYGEN.START_AIR_DRAIN:
			TimerOxygen.start(Parameters.OXYGEN_CHIME_1)
			OxygenState = OXYGEN.WARNING_CHIME_1
		OXYGEN.WARNING_CHIME_1:
			SndOxygenChime.play()
			TimerOxygen.start(Parameters.OXYGEN_CHIME_2)
			OxygenState = OXYGEN.WARNING_CHIME_2
		OXYGEN.WARNING_CHIME_2:
			SndOxygenChime.play()
			TimerOxygen.start(Parameters.OXYGEN_CHIME_3)
			OxygenState = OXYGEN.WARNING_CHIME_3
		OXYGEN.WARNING_CHIME_3:
			SndOxygenChime.play()
			TimerOxygen.start(Parameters.OXYGEN_BUBBLE_5)
			OxygenState = OXYGEN.WARNING_BUBBLE_5
		OXYGEN.WARNING_BUBBLE_5:
			PlayDrowningMusic.emit(true)
			TimerOxygen.start(Parameters.OXYGEN_BUBBLE_4)
			OxygenState = OXYGEN.WARNING_BUBBLE_4
		OXYGEN.WARNING_BUBBLE_4:
			TimerOxygen.start(Parameters.OXYGEN_BUBBLE_3)
			OxygenState = OXYGEN.WARNING_BUBBLE_3
		OXYGEN.WARNING_BUBBLE_3:
			TimerOxygen.start(Parameters.OXYGEN_BUBBLE_2)
			OxygenState = OXYGEN.WARNING_BUBBLE_2
		OXYGEN.WARNING_BUBBLE_2:
			TimerOxygen.start(Parameters.OXYGEN_BUBBLE_1)
			OxygenState = OXYGEN.WARNING_BUBBLE_1
		OXYGEN.WARNING_BUBBLE_1:
			TimerOxygen.start(Parameters.OXYGEN_BUBBLE_0)
			OxygenState = OXYGEN.WARNING_BUBBLE_0
		OXYGEN.WARNING_BUBBLE_0:
			TimerOxygen.start(Parameters.OXYGEN_LAST_GASP)
			OxygenState = OXYGEN.EMPTY
		OXYGEN.EMPTY:
			Kill()



func IsOnWaterSurface() -> bool:
	return WaterSurfaceCast.is_colliding()


func BreatheAirBubble() -> void:
	OxygenState = OXYGEN.START_AIR_DRAIN
	TimerOxygen.stop()
	UpdateOxygenState()
	SndWaterBreathe.play()
	CanJump = false
	velocity = Vector3.ZERO
	StateM.ChangeState("Fall")


func SetInvincible(time: float) -> void:
	if time > 0.0:
		Invincible = true
		TimerInvincibility.start(time)
	else:
		Invincible = false
		TimerInvincibility.stop()


func SetFlicker(time: float) -> void:
	if time > 0.0:
		Flicker = true
		TimerFlicker.start(time)
	else:
		Flicker = false
		CharMesh.visible = true
		TimerFlicker.stop()


func SetShieldState(newState: SHIELD) -> void:	
	if ShieldState != SHIELD.NONE:
		remove_child(CurrentShield)
		CurrentShield.queue_free()
		CurrentShield = null
	
	ShieldState = newState
	if ShieldState == SHIELD.NONE:
		return
	
	match newState:
		SHIELD.NORMAL_SHIELD:
			CurrentShield = NORMAL_SHIELD.instantiate()
		SHIELD.FIRE_SHIELD:
			CurrentShield = FIRE_SHIELD.instantiate()
		SHIELD.WATER_SHIELD:
			CurrentShield = WATER_SHIELD.instantiate()
		SHIELD.THUNDER_SHIELD:
			CurrentShield = THUNDER_SHIELD.instantiate()
		
	add_child(CurrentShield)


func OrientCharMesh() -> void:
	assert(velocity.length() > 0.0)
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
		VelocityIndicator.transform = Transform3D.IDENTITY.looking_at(VelocityIndicator.position + (VelocityIndicator.position - velocity.normalized()) + Vector3(0.0001, 0.0001, 0.0001))
	else:
		VelocityIndicator.scale = Vector3.ZERO


func CreateCollisionIndicator(point: Vector3, normal: Vector3) -> void:
	var collInd = COLLISION_INDICATOR.instantiate()
	get_parent().add_child(collInd)
	collInd.SetToVectors(point, normal)


func CreateSmoke() -> void:
	var newSmoke = SMOKE.instantiate()
	get_parent().add_child(newSmoke)
	newSmoke.global_position = global_position


func _on_timer_invincibility_timeout() -> void:
	SetInvincible(-1.0)
	SetFlicker(-1.0)


func _on_timer_flicker_timeout() -> void:
	SetFlicker(-1.0)


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
			DashModeCharge += Parameters.DASHMODE_INCREMENT_ENEMY




func _on_hitbox_hitbox_activated(Target: Hurtbox) -> void:
	AttackHit(Target)


func DamageReceived(SourcePos: Vector3, Damage: int) -> void:
	if Invincible or (Damage < DamageThreshold) or StateM.CurrentState == "Death":
		return
	
	if ShieldState != SHIELD.NONE:
		SetShieldState(SHIELD.NONE)
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
	HealthEmpty.emit()
	SetDashMode(false)
	SetShieldState(SHIELD.NONE)
	
	var deathState = "DROWN" if IsUnderwater else "NORMAL"
	
	StateM.ChangeState("Death", {
		"DeathType": deathState,
	})


func _on_hurtbox_hurtbox_activated(Source: Hitbox, Damage: int) -> void:
	DamageReceived(Source.global_position, Damage)
