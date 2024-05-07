extends BasicState



var AttackReleased := false

var Target : Node3D = null
var TargetPos := Vector3.ZERO
var AttackVector := Vector3.ZERO
var TargetSeek := true


func _ready() -> void:
	DebugMenu.AddMonitor(self, "Target")
	DebugMenu.AddMonitor(self, "TargetPos")
	DebugMenu.AddMonitor(self, "AttackVector")
	DebugMenu.AddMonitor(self, "TargetSeek")


func Enter(_msg := {}) -> void:
	owner.AnimTree.set("parameters/AirSpinKick/blend_amount", 1.0)
	owner.ToggleHitbox(true)
	
	AttackReleased = false
	
	owner.FloorNormal = Vector3.UP
	owner.up_direction = Vector3.UP
	
	AttackVector = (owner.velocity * Vector3(1, 0, 1)).normalized()


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
			var targetPos = i.global_position
			if AttackVector.dot((owner.global_position.direction_to(targetPos))) > 0.75:
				if Target == null:
					Target = i
				else:
					if owner.global_position.distance_to(i.global_position) < owner.global_position.distance_to(Target.global_position):
						Target = i
	
		if Target:
			print("Found Target: pos: %s" % Target.global_position)
			return true
	return false


func TargetMovement(_delta) -> void:
		var direction = owner.global_position.direction_to(Target.global_position).normalized()
		owner.Move(direction)


func NormalMovement(_delta) -> void:
	get_parent().UpdateInput(_delta)
	get_parent().AirMove(_delta, get_parent().InputVel)


func AttackHit(_Target: Hurtbox) -> void:
	Target = null
	get_parent().AirVel.y = owner.PARAMETERS.ATTACK_BOUNCE_POW
	owner.DashModeCharge += 0.2
	_Target.ReceiveDamage(owner.HitBox, 1)
