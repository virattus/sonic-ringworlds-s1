extends BasicState


var HorizVelocity := Vector3.ZERO
var VerticalVelocity := 0.0
var AirDashSpeed := 0.0


func Enter(_msg := {}) -> void:
	owner.AnimTree.set("parameters/Movement/blend_amount", 1.0)
	owner.AnimTree.set("parameters/Air/blend_amount", 1.0)
	
	owner.SndAirdash.play()
	
	HorizVelocity = (owner.velocity * Vector3(1, 0, 1)).normalized()
	VerticalVelocity = owner.velocity.y
	AirDashSpeed = owner.PARAMETERS.AIRDASH_INITIAL_SPEED


func Exit() -> void:
	owner.SndAirdash.stop()


func Update(_delta: float) -> void:
	if owner.CheckGroundCollision():
		ChangeState("Land")
		return
	
	AirDashSpeed -= owner.PARAMETERS.AIRDASH_SPEED_DECREASE_RATE * _delta
	if AirDashSpeed <= 0.0:
		ChangeState("Fall")
		return
	
	
	VerticalVelocity -= owner.PARAMETERS.GRAVITY * _delta
	
	var vel = HorizVelocity * AirDashSpeed
	vel.y += VerticalVelocity
	
	owner.CharGroundCast.target_position = (owner.velocity.normalized())
	
	owner.Move(vel)
	owner.CharMesh.look_at(owner.global_position + HorizVelocity)
