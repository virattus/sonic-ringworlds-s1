extends BasicState


var HorizVelocity := Vector3.ZERO
var VerticalVelocity := 0.0
var AirDashSpeed := 0.0

const COLLISION_INDICATOR = preload("res://entities/Collision/Collision.tscn")

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
	VerticalVelocity -= owner.PARAMETERS.GRAVITY * _delta
	
	var vel = HorizVelocity * AirDashSpeed
	vel.y += VerticalVelocity
	
	owner.CharGroundCast.target_position = (owner.velocity.normalized()) * owner.CharGroundCastLength
	
	owner.Move(vel)
	owner.CharMesh.look_at(owner.global_position + HorizVelocity)
	
	
	for i in range(owner.get_slide_collision_count()):
		var collision = owner.get_slide_collision(i)
		var coll = COLLISION_INDICATOR.instantiate()
		owner.get_parent().add_child(coll)
		coll.SetToCollision(collision)
		
		var dot = owner.up_direction.dot(collision.get_normal())
		if dot > owner.PARAMETERS.LAND_ANGLE_MAX:
			owner.FloorNormal = collision.get_normal()
			owner.up_direction = collision.get_normal()
			ChangeState("Land")
			return
		elif dot > owner.PARAMETERS.WIPEOUT_ANGLE_MAX:
			var walldot = collision.get_normal().dot(owner.CharMesh.GetForwardVector().normalized())
			if walldot < -0.5:
				print("Airdash: bounce off wall: ", walldot)
				owner.FloorNormal = collision.get_normal()
				owner.up_direction = collision.get_normal()
				ChangeState("Hurt", {
					"Bonk": true,
					"BounceDirection" : owner.get_wall_normal() * 3.0
				})
				return
		else:
			print("Ceiling hit?")
	
	AirDashSpeed -= owner.PARAMETERS.AIRDASH_SPEED_DECREASE_RATE * _delta
	if AirDashSpeed <= 0.0:
		ChangeState("Fall")
		return
