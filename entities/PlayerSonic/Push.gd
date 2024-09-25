extends "res://entities/Player/Push.gd"




func Enter(_msg := {}) -> void:
	owner.AnimTree.set("parameters/Movement/blend_amount", 0.0)
	owner.AnimTree.set("parameters/Push/blend_amount", 1.0)
	
	print("pushing")


func Exit() -> void:
	owner.AnimTree.set("parameters/Push/blend_amount", 0.0)


func Update(_delta: float) -> void:
	owner.Move()
	
	var inputVel : Vector3 = owner.GetInputVector(owner.up_direction)
	
	if inputVel.length() == 0.0:
		ChangeState("Idle")
		return
	
	if owner.is_on_wall():
		var wallNorm : Vector3 = owner.get_wall_normal()
		owner.SetCollisionCastDir(wallNorm)
		owner.CollisionCast.force_raycast_update()
		if !owner.CollisionCast.is_colliding():
			owner.SetCollisionCastDir(-owner.up_direction)
			ChangeState("Move")
			return
		else:
			var realWallNorm : Vector3 = owner.CollisionCast.get_collision_normal()
			if realWallNorm.dot(inputVel.normalized()) > -0.25:
				owner.SetCollisionCastDir(-owner.up_direction)
				ChangeState("Move")
				return
			else:
				owner.CharMesh.LerpMeshOrientation(wallNorm)
				
				owner.SetVelocity(inputVel * _delta)
	else:
		ChangeState("Move")
		return
	
