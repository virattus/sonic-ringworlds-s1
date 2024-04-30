extends BasicState


var HorizVelocity := Vector3.ZERO
var VerticalVelocity := 0.0
var AirDashSpeed := 0.0


func Enter(_msg := {}) -> void:
	owner.AnimTree.set("parameters/Air/blend_amount", 1.0)
	
	owner.AirdashTrail.Active = true
	
	owner.SndAirdash.play()
	
	owner.FloorNormal = Vector3.UP
	owner.up_direction = Vector3.UP
	
	
	var ControlAxis = owner.Controller.InputAnalogue
	var ControlVel = (owner.Camera.CurrentBasis * Vector3(ControlAxis.x, 0.0, ControlAxis.y))
	
	HorizVelocity = ((owner.velocity * Vector3(1, 0, 1) * owner.Speed) + ControlVel).normalized()
	VerticalVelocity = owner.velocity.y
	AirDashSpeed = owner.PARAMETERS.AIRDASH_INITIAL_SPEED


func Exit() -> void:
	owner.AirdashTrail.Active = false
	owner.SndAirdash.stop()


func Update(_delta: float) -> void:
	var collision : SonicCollision = get_parent().CollisionDetection()
	if collision != null:
		if collision.CollisionType == SonicCollision.COLL_TYPE.BOTTOM:
			print("AirDash: Hit floor")
			ChangeState("Land")
			return
		if collision.CollisionType == SonicCollision.COLL_TYPE.SIDE:
			var dot = collision.CollisionNormal.dot(owner.CharMesh.GetForwardVector().normalized())
			if dot < owner.PARAMETERS.AIRDASH_WALL_BONK:
				print("AirDash: Wall Bonk")
				ChangeState("Hurt", {
					"Bonk": true,
					"BounceDirection": owner.get_wall_normal() * 3.0,
				})
				return
			else:
				print("AirDash: Wall Dot " + str(dot))
	
	owner.CharMesh.look_at(owner.global_position + (owner.velocity * Vector3(1, 0, 1)))
	
	var airVel = get_parent().AirVel
	get_parent().AirVel = ((airVel * Vector3(1, 0, 1)).normalized() * AirDashSpeed) + (Vector3.UP * airVel.y)
	
	AirDashSpeed -= owner.PARAMETERS.AIRDASH_SPEED_DECREASE_RATE * _delta
	if AirDashSpeed <= 0.0:
		ChangeSubState("Fall")
		return
	

	
