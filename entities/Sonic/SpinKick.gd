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
	owner.ToggleHitbox(true)
	
	AttackReleased = false
	
	owner.FloorNormal = Vector3.UP
	owner.up_direction = Vector3.UP


func Exit() -> void:
	owner.AnimTree.set("parameters/AirSpinKick/blend_amount", 0.0)
	owner.ToggleHitbox(false)


func Update(_delta: float) -> void:
	var Homing := false
	
	if Input.is_action_pressed("Attack"):
		if Target == null:
			if !AttackReleased and get_parent().AirVel.y <= 0.0:
				if FindTarget():
					Homing = true
		else:
			Homing = true
	else:
		AttackReleased = true
	
	if Homing:
		TargetMovement(_delta)
	else:
		NormalMovement(_delta)
	
	if owner.is_on_floor():
		ChangeState("Land")
		return


func FindTarget() -> bool:
	if owner.LockOnArea.has_overlapping_bodies():
		var targets = owner.LockOnArea.get_overlapping_bodies()
		for i in targets:
			if Target == null:
				Target = i
			else:
				if owner.global_position.distance_to(i.global_position) < owner.global_position.distance_to(Target.global_position):
					Target = i
		
		print("Found Target: pos: %s" % Target.global_position)
		return true
	else:
		return false
	


func TargetMovement(_delta) -> void:
		var direction = owner.global_position.direction_to(Target.global_position).normalized()
		owner.Move(direction)


func NormalMovement(_delta) -> void:
	get_parent().UpdateInput(_delta)
	var inputVel = (get_parent().InputVel * get_parent().InputSpeed)
	get_parent().AirMove(_delta, inputVel)


func AttackHit(_Target: Hurtbox) -> void:
	Target = null
	get_parent().AirVel.y = owner.PARAMETERS.ATTACK_BOUNCE_POW
	owner.DashModeCharge += 0.2
	_Target.ReceiveDamage(owner.HitBox, 1)
