extends "res://entities/Player/MoveAir.gd"


var Target : Enemy = null

var AttackReleased := false

var CurrentSpeed := 0.0

const SPINKICK_INPUT_MOD = 5.0


func _ready() -> void:
	DebugMenu.AddMonitor(self, "Target")


func Enter(_msg := {}) -> void:
	owner.UpdateUpDir(Vector3.UP, -1.0)
	owner.CharMesh.AlignToY(Vector3.UP)
	owner.AnimTree.set("parameters/AirSpinKick/blend_amount", 1.0)
	
	owner.ActivateHitbox(true)
	
	CurrentSpeed = (owner.velocity * Vector3(1, 0, 1)).length()


func Exit() -> void:
	owner.AnimTree.set("parameters/AirSpinKick/blend_amount", 0.0)
	
	owner.ActivateHitbox(false)
	AttackReleased = false
	Target = null


func Update(_delta: float) -> void:
	owner.Move()
	
	var collision : CharCollision = owner.GetCollision()
	if CheckGroundCollision(collision):
		ChangeState("Land")
		return
	
	if Input.is_action_just_released("Attack"):
		AttackReleased = true
	
	var inputVel = owner.GetInputVector(owner.up_direction)
	
	if !TargetStillValid():
		self.Target == null
	
	if !AttackReleased and Target == null:
		GetNextTarget(inputVel)
	
	var newVel = owner.TrueVelocity
	
	newVel = owner.ApplyGravity(newVel, _delta)
	
	if AttackReleased or Target == null:
		newVel += inputVel * SPINKICK_INPUT_MOD * _delta
		newVel = ApplyAirDrag(newVel, _delta)
	else:
		var direction = owner.global_position.direction_to(Target.global_position)
		newVel = (direction * Vector3(1, 0, 1) * CurrentSpeed) + (newVel * Vector3.UP)
	
	
	owner.SetTrueVelocity(newVel)
	owner.SetVelocity(newVel)


func TargetStillValid() -> bool:
	if Target == null:
		return false
	
	return true
	


const FRAME_DELTA = 0.16666667 #Hard coded 60FPS
func TargetTrajectoryMinSpeed(newTarget: Enemy) -> float:
	#Calculate the minimum speed required to reach the target
	
	var VertDistanceTo = (owner.global_position * Vector3(0, 1, 0)).distance_to(newTarget.global_position * Vector3(0, 1, 0))
	
	if VertDistanceTo <= 0.0:
		return INF
	
	var HorizDistanceTo = (owner.global_position * Vector3(1, 0, 1)).distance_to(newTarget.global_position * Vector3(1, 0, 1))
	
	#brute force calculate number of frames it'll take to reach target
	var frameCount := 0
	var vertVel = owner.velocity.y
	while vertVel > newTarget.global_position.y:
		vertVel -= owner.CurrentGravity * FRAME_DELTA
		#vertVel -= owner.PARAMETERS.GRAVITY * FRAME_DELTA
	
	return HorizDistanceTo / (VertDistanceTo / (owner.CurrentGravity * FRAME_DELTA))
	#return HorizDistanceTo / (VertDistanceTo / (owner.PARAMETERS.GRAVITY * FRAME_DELTA))
	#return HorizDistanceTo / frameCount


func TargetTrajectoryPossible(newTarget: Enemy) -> bool:
	#Calculate the distance to a potential target, figure out if Sonic's trajectory can even hit it
	
	#It might make sense to create a table of Sonic's y position based on time
	#Don't forget that we need to calculate based on the TOP of the target, since we're bouncing off
	return true
	


func GetNextTarget(inputDir: Vector3) -> void:
	var potentialTargets = owner.LockOnArea.get_overlapping_bodies()
	
	if potentialTargets.size() == 0:
		return
	
	#Filter out defeated enemies, I know, this can be done better
	for i in potentialTargets:
		if i.EnemyDefeated:
			potentialTargets.erase(i)
	
	var forwardVector = inputDir.normalized()
	if forwardVector.length() == 0.0:
		forwardVector = (owner.velocity * Vector3(1, 0, 1)).normalized()
	
	#Check if targets are being pointed toward by the player
	for i in potentialTargets:
		if forwardVector.dot((owner.global_position.direction_to(i.global_position) * Vector3(1, 0, 1)).normalized()) < 0.0:
			potentialTargets.erase(i) 
	
	
	if potentialTargets.size() == 0:
		#no valid targets
		return
	
	
	var closest = null
	var newSpeed = 0.0
	for i in potentialTargets:
		var TargetSpeed = TargetTrajectoryMinSpeed(i)
		if TargetSpeed < CurrentSpeed:
			if closest == null:
				closest = i
				newSpeed = TargetSpeed
			else:
				if owner.global_position.distance_to(i.global_position) < owner.global_position.distance_to(closest.global_position):
					closest = i
					newSpeed = TargetSpeed
	
	if closest == null:
		return
	
	Target = closest
	CurrentSpeed = newSpeed
	print("SpinKick: Found target: Distance: %s TargetSpeed: %s" % [owner.global_position.distance_to(Target.global_position), CurrentSpeed])


func AttackHit(_Target: Hurtbox) -> void:
	print("SpinKick: Hit enemy")
	owner.velocity.y = owner.PARAMETERS.ATTACK_BOUNCE_POW
	Target = null
