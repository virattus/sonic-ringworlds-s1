extends "res://entities/Player/MoveGround.gd"


var IgnoreInputAccumulator := 0.0

var FootstepAccumulator := 0.0


const BOUNCE_REFLECTION_POWER = 3.0
const BOUNCE_MIN_SPEED = 8.0

const WALK_BRAKE_POWER = 8.0

const MOVE_NO_STICK_REDUCTION = 3.0

const RUN_FRICTION_SPEED = 0.046875

const RUN_RATIO_DIVISOR = 200.0

const MOVE_CHARMESH_VEL_ORIENT_MIN_SPEED = 2.0

const FOOTSTEP_TIME_MOD = 0.5


const WATER_RUN_SPLASH = preload("res://effects/WaterRunSplash/WaterRunSplash.tscn")


func Enter(_msg := {}) -> void:
	owner.AnimTree.set("parameters/Movement/blend_amount", 0.0)
	owner.AnimTree.set("parameters/Ground/blend_amount", 1.0)
	owner.AnimTree.set("parameters/GroundSecondary/blend_amount", -1.0)
	
	if _msg.has("Velocity"):
		owner.SetVelocity(_msg["Velocity"])
	
	if _msg.has("IgnoreInput"):
		IgnoreInputAccumulator = _msg["IgnoreInput"]
		
	if _msg.has("Boost"):
		owner.SetTrueVelocity(_msg["Boost"])
		owner.SetVelocity(_msg["Boost"])
		owner.SndSpinLaunch.play()
	
	if _msg.has("UpdateModelOrientation") and _msg["UpdateModelOrientation"]:
		owner.CharMesh.LerpMeshOrientation(owner.global_position + owner.velocity, -1.0)

	
	UpdateMoveAnimations()


func Exit() -> void:
	IgnoreInputAccumulator = 0.0
	owner.SetRunOnWater(false)
	

func Update(_delta: float) -> void:
	if !HandleMovementAndCollisions(_delta):
		return
		
#	var collision : CharCollision = owner.GetCollision()
#	if !CheckGroundCollision(collision, _delta):
#		owner.SetVelocity(owner.TrueVelocity)
#		owner.SetTrueVelocity(owner.TrueVelocity + owner.BounceVelocity)
#		owner.BounceVelocity = Vector3.ZERO
#		ChangeState("Fall")
#		return
	
	
	if Input.is_action_just_pressed("Jump"):
		if !HandleJumpInput():
			return
	
	if Input.is_action_just_pressed("Attack"):
		if !HandleAttackInput():
			return
	
	IgnoreInputAccumulator = move_toward(IgnoreInputAccumulator, 0.0, _delta)
	
	UpdateMoveAnimations()
	
	if owner.TrueVelocity.length() > owner.Parameters.WALK_MAX_SPEED:
		owner.SetRunOnWater(true)
	else:
		owner.SetRunOnWater(false)

	
	var newVel : Vector3 = owner.TrueVelocity
	var inputVel : Vector3 = owner.GetInputVector(owner.up_direction)
	if IgnoreInputAccumulator > 0.0:
		inputVel = Vector3.ZERO

	if owner.is_on_wall():
		if owner.TrueVelocity.length() > BOUNCE_MIN_SPEED:
			owner.BounceVelocity = newVel.bounce(owner.get_wall_normal()).normalized() * BOUNCE_REFLECTION_POWER
			owner.SndSkid.play()
			newVel = Vector3.ZERO
		elif owner.PushCast.is_colliding():
			if owner.up_direction.dot(Vector3.UP) > 0.9:
				var collNormal : Vector3 = owner.PushCast.get_collision_normal()
				#if collNormal.dot(owner.velocity.normalized()) < -0.25:
				if collNormal.dot(inputVel.normalized()) < -0.25:
					ChangeState("Push")
					return

	if !owner.GroundCollision and owner.IsOnWaterSurface(): #raycast doesn't hit solid ground idiot
		UpdateWaterFootsteps(_delta)

	if inputVel.length() > 0.0:
		#only update model's direction if player moves stick
		if owner.velocity.length() > 0.0:
			owner.OrientCharMesh()
		
		if owner.IsInputSkidding(inputVel):
			if newVel.length() > owner.Parameters.WALK_MAX_SPEED:
				#Don't skid on water
				if owner.GroundCollision:
					if HandleSkid(inputVel):
						return
			else:
				newVel = newVel.move_toward(Vector3.ZERO, _delta * WALK_BRAKE_POWER)
		else:
			if newVel.length() > owner.Parameters.WALK_MAX_SPEED:
				newVel = CalculateRunVelocity(newVel, inputVel, _delta)
			else:
				newVel = CalculateWalkVelocity(newVel, inputVel, _delta)
	else:
		newVel = newVel.move_toward(Vector3.ZERO, _delta * MOVE_NO_STICK_REDUCTION)
	
	
	if owner.BounceVelocity.is_zero_approx():
		owner.BounceVelocity = Vector3.ZERO
		owner.SndSkid.stop()
		if newVel.is_zero_approx():
			ChangeState("Idle")
			return
	else:
		owner.CreateSmoke()
		
	owner.SetTrueVelocity(newVel)
	owner.SetVelocity(newVel + owner.BounceVelocity)
	


func UpdateWaterFootsteps(delta: float) -> void:
	FootstepAccumulator += delta
	if FootstepAccumulator > (1.0 - (owner.Speed / owner.Parameters.MOVE_MAX_SPEED)) * FOOTSTEP_TIME_MOD:
		owner.SndWaterRunFootstep.play()
		var splash = WATER_RUN_SPLASH.instantiate()
		owner.get_parent().add_child(splash)
		splash.global_transform = owner.CharMesh.global_transform
			
		FootstepAccumulator = 0.0


func UpdateMeshOrientation(Backwards: bool) -> void:
	var vel = owner.TrueVelocity.normalized()
	if Backwards:
		vel = -vel
	
	owner.CharMesh.LookAt(owner.global_position + vel)
	owner.CharMesh.AlignToY(owner.up_direction)


func CalculateWalkVelocity(vel: Vector3, inputVel: Vector3, delta: float) -> Vector3:
	var speedMod = owner.Parameters.WALK_SPEED_POWER
	if owner.IsUnderwater:
		speedMod = owner.Parameters.WALK_SPEED_POWER / 2.0
	
	var inputValue : Vector3 = (inputVel * speedMod * delta) + (inputVel.normalized() * vel.length())
	var newVel = inputValue
	
	return newVel


func CalculateRunVelocity(vel: Vector3, inputVel: Vector3, delta: float) -> Vector3:
	var newVel : Vector3 = vel
	
	var ratio : float = (owner.Speed - owner.Parameters.WALK_MAX_SPEED) / RUN_RATIO_DIVISOR
	#print("Run ratio: %s" % ratio)
	
	var SpeedPower : float = owner.Parameters.RUN_SPEED_POWER if !owner.IsUnderwater else owner.Parameters.RUN_SPEED_POWER * 0.5
	
	var newSpeed : float = (newVel + (inputVel * SpeedPower * delta)).length()
	
	if newVel.length() >= owner.Parameters.RUN_MAX_SPEED:
		newSpeed = lerp(newSpeed, owner.Parameters.RUN_MAX_SPEED, delta)
	
	newVel = (newVel * ratio) + ((inputVel * SpeedPower * delta) * (1.0 - ratio))
	
	newVel = newVel.normalized() * newSpeed
	
	#newVel = owner.ApplyDrag(newVel, delta)
	
	#Remove excess velocity for curves/spheres
	newVel = newVel - (owner.up_direction * owner.up_direction.dot(newVel))
	
	return newVel


func HandleSkid(input: Vector3) -> bool:
	if input.length() > owner.Parameters.SKID_MIN_STICK_MAGNITUDE:
		ChangeState("Skid")
		return true
	
	return false


func UpdateMoveAnimations() -> void:
	if owner.DashMode:
		if owner.Speed > owner.Parameters.WALK_MAX_SPEED:
			owner.AnimTree.set("parameters/StrikeDash/blend_amount", 1.0)
			owner.AnimTree.set("parameters/TSStrikeDash/scale", owner.Speed * owner.Parameters.SPRINT_ANIM_SPEED_MOD)
		else:
			owner.AnimTree.set("parameters/StrikeDash/blend_amount", 0.0)
			owner.AnimTree.set("parameters/Run/blend_amount", -1.0)
			owner.AnimTree.set("parameters/TSWalk/scale", owner.Speed * owner.Parameters.WALK_ANIM_SPEED_MOD)
	else:
		owner.AnimTree.set("parameters/StrikeDash/blend_amount", 0.0)
		if owner.Speed > owner.Parameters.RUN_MAX_SPEED:
			owner.AnimTree.set("parameters/Run/blend_amount", 1.0)
			owner.AnimTree.set("parameters/TSSprint/scale", owner.Speed * owner.Parameters.SPRINT_ANIM_SPEED_MOD)
		elif owner.Speed > owner.Parameters.WALK_MAX_SPEED:
			owner.AnimTree.set("parameters/Run/blend_amount", 0.0)
			owner.AnimTree.set("parameters/TSRun/scale", owner.Speed * owner.Parameters.RUN_ANIM_SPEED_MOD)
		else:
			owner.AnimTree.set("parameters/Run/blend_amount", -1.0)
			owner.AnimTree.set("parameters/TSWalk/scale", owner.Speed * owner.Parameters.WALK_ANIM_SPEED_MOD)


func HandleJumpInput() -> bool:
	ChangeState("Jump", {
			"JumpSound": true,
	})
	return false


func HandleAttackInput() -> bool:
	return true
