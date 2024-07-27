extends BasicState




func Enter(_msg := {}) -> void:
	pass


func Exit() -> void:
	pass


func Update(_delta: float) -> void:
	pass


func AttackHit(_Target: Hurtbox) -> void:
	print("Ball: Hit enemy")
	if !owner.is_on_floor():
		owner.velocity.y = owner.PARAMETERS.ATTACK_BOUNCE_POW
	owner.DashModeCharge += 0.2


func UncurlAndIdle() -> void:
	owner.CharMesh.look_at(owner.global_position + owner.velocity)
	owner.CharMesh.AlignToY(owner.up_direction)
	ChangeState("Idle")
	
