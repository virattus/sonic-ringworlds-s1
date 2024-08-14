extends "res://entities/Sonic/MoveAir.gd"


var Target : Node3D = null

var AttackReleased := false


func Enter(_msg := {}) -> void:
	owner.AnimTree.set("parameters/AirSpinKick/blend_amount", 1.0)
	
	owner.ActivateHitbox(true)


func Exit() -> void:
	owner.AnimTree.set("parameters/AirSpinKick/blend_amount", 0.0)
	AttackReleased = false


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
	
	if AttackReleased:
		var inputVel = owner.GetInputVector(owner.up_direction)
		newVel += inputVel * _delta
		newVel = ApplyDrag(newVel, _delta)
	else:
		if Target != null:
			newVel.move_toward((Target.global_position - owner.global_position) * Vector3(1, 0, 1), _delta)
	
	newVel = owner.ApplyGravity(newVel, _delta)
	
	owner.SetVelocity(newVel)


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
	
	
	var closest = potentialTargets[0]
	for i in potentialTargets:
		if owner.global_position.distance_to(i.global_position) < owner.global_position.distance_to(closest.global_position):
			closest = i
	
	Target = closest
	
	print(potentialTargets.size())


func AttackHit(_Target: Hurtbox) -> void:
	print("SpinKick: Hit enemy")
	owner.DashModeCharge += 0.2
	owner.velocity.y = owner.PARAMETERS.ATTACK_BOUNCE_POW
	Target = null
