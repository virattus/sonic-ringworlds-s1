extends "res://entities/Sonic/MoveAir.gd"


var Target : Enemy = null
var PrevTarget : Enemy = null

var AttackReleased := false

const SPINKICK_INPUT_MOD = 5.0


func _ready() -> void:
	DebugMenu.AddMonitor(self, "Target")


func Enter(_msg := {}) -> void:
	owner.AnimTree.set("parameters/AirSpinKick/blend_amount", 1.0)
	
	owner.ActivateHitbox(true)


func Exit() -> void:
	owner.AnimTree.set("parameters/AirSpinKick/blend_amount", 0.0)
	
	owner.ActivateHitbox(false)
	AttackReleased = false
	Target = null


func Update(_delta: float) -> void:
	owner.Move()
	
	if HandleCollisions():
		ChangeState("Land")
		return
	
	if Input.is_action_just_released("Attack"):
		AttackReleased = true
	
	if !AttackReleased and Target == null:
		GetNextTarget()
	
	var newVel = owner.velocity
	
	if AttackReleased or Target == null:
		var inputVel = owner.GetInputVector(owner.up_direction)
		newVel += inputVel * SPINKICK_INPUT_MOD * _delta
		newVel = ApplyDrag(newVel, _delta)
	else:
		var direction = owner.global_position.direction_to(Target.global_position)
		var distanceTo = owner.global_position.distance_to(Target.global_position)
		print("direction: %s distanceTo: %s" % [direction, distanceTo])
		newVel = (direction * distanceTo * Vector3(1, 0, 1)) + (newVel * Vector3.UP)

	
	newVel = owner.ApplyGravity(newVel, _delta)
	
	owner.SetVelocity(newVel)


func TargetStillValid() -> void:
	if Target == null:
		return
	
	


func GetNextTarget() -> void:
	var potentialTargets = owner.LockOnArea.get_overlapping_bodies()
	
	if potentialTargets.size() == 0:
		return
	
	var forwardVector = (owner.velocity * Vector3(1, 0, 1)).normalized()
	
	#Filter out defeated enemies, I know, this can be done better
	var invalidTargets = []
	for i in potentialTargets:
		if i.EnemyDefeated:
			invalidTargets.push_back(i)
	
	for i in range(invalidTargets.size()):
		potentialTargets.erase(i)
	
	potentialTargets.erase(PrevTarget)
	
	if potentialTargets.size() == 0:
		#no valid targets
		return
	
	
	var closest = potentialTargets[0]
	for i in potentialTargets:
		if owner.global_position.distance_to(i.global_position) < owner.global_position.distance_to(closest.global_position):
			closest = i
	
	Target = closest


func AttackHit(_Target: Hurtbox) -> void:
	print("SpinKick: Hit enemy")
	owner.DashModeCharge += 0.2
	owner.velocity.y = owner.PARAMETERS.ATTACK_BOUNCE_POW
	PrevTarget = Target
	Target = null
