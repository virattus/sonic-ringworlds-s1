extends BasicState



var AttackReleased := false

var Target : Node3D = null
var TargetPos := Vector3.ZERO
var TargetSeek := true
#We're getting a race condition where we detect and home in on an enemy that doesn't know that it's dead yet,
#but is dead by the time we start moving toward its position, so we'll keep a list of killed enemies
#that gets cleared when we call FindTarget, so there's a frame break
var InvalidTargets = [] 


func Enter(_msg := {}) -> void:
	owner.AnimTree.set("parameters/AirSpinKick/blend_amount", 1.0)
	owner.ToggleAttackArea(true)
	
	AttackReleased = false
	
	owner.FloorNormal = Vector3.UP
	owner.up_direction = Vector3.UP


func Exit() -> void:
	owner.AnimTree.set("parameters/AirSpinKick/blend_amount", 0.0)
	owner.ToggleAttackArea(false)


func Update(_delta: float) -> void:
	if Input.is_action_pressed("Attack"):
		if !AttackReleased and get_parent().AirVel.y <= 0.0:
			pass
	else:
		AttackReleased = true
	
	if owner.is_on_floor():
		ChangeState("Land")
		return


func FindTarget() -> bool:
	if owner.TargetArea.has_overlapping_bodies():
		var targets = owner.TargetArea.get_overlapping_bodies()
		for i in targets:
			if Target == null:
				Target = i
			else:
				if owner.global_position.distance_to(i.global_position) < owner.global_position.distance_to(Target.global_position):
					Target = i
		
		return true
	else:
		return false
	


func TargetMovement(_delta) -> bool:
	if !is_instance_valid(Target):
		return false
	else:
		var direction = owner.global_position.direction_to(Target.global_position).normalized()
		owner.SetVelocity(direction)
		return true


func AttackHit(body: Node3D) -> void:
	Target = null
	get_parent().AirVel.y = owner.PARAMETERS.ATTACK_BOUNCE_POW
	body.ReceiveDamage(owner.AttackArea, 1)
