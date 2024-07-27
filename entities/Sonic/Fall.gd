extends "res://entities/Sonic/MoveAir.gd"




func Enter(_msg := {}) -> void:
	owner.AnimTree.set("parameters/Movement/blend_amount", 1.0)
	owner.AnimTree.set("parameters/Air/blend_amount", 0.0)
	
	owner.GroundCollision = false


func Exit() -> void:
	pass


func Update(_delta: float) -> void:
	owner.Move()
	
	var collision : SonicCollision = owner.GetCollision()
	
	if collision.CollisionType != SonicCollision.NONE:
		owner.GroundCollision = true
		var type = "Normal"
		var normal = collision.CollisionNormal
		if collision.CollisionType == SonicCollision.WALL:
			if Vector3.UP.dot(owner.up_direction) < 0.5:
				if owner.up_direction.dot(collision.CollisionNormal) < 0.5:
					type = "Wipeout"
		elif collision.CollisionType == SonicCollision.CEILING:
			#Landed upside down, need to get a floor normal
			type = "Wipeout"
			owner.GroundCast.force_raycast_update()
			normal = owner.GroundCast.get_collision_normal()
				
		ChangeState("Land", {
			"Type": type,
			"Normal": normal,
		})
		return

	var newVel = owner.velocity
	var inputVel = owner.GetInputVector(Vector3.UP)
	
	newVel += inputVel * _delta
	
	newVel = ApplyDrag(newVel, _delta)

	owner.SetVelocity(newVel)
	owner.ApplyGravity(_delta)
