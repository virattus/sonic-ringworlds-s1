extends "res://entities/Player/Push.gd"


var WallNormal := Vector3.ZERO

const PUSH_SPEED = 8.0


func Enter(_msg := {}) -> void:
	owner.AnimTree.set("parameters/Movement/blend_amount", 0.0)
	owner.AnimTree.set("parameters/Push/blend_amount", 1.0)
	
	owner.SetTrueVelocity(owner.velocity)
	
	#print("pushing")


func Exit() -> void:
	owner.AnimTree.set("parameters/Push/blend_amount", 0.0)


func Update(_delta: float) -> void:
	owner.Move()
	
	var inputVel : Vector3 = owner.GetInputVector(owner.up_direction)
	
	if inputVel.length() == 0.0:
		ChangeState("Idle")
		return
	
	if !UpdateWallNormal():
		ChangeState("Move")
		return
	
	
	if WallNormal.dot(inputVel.normalized()) > -0.25:
		ChangeState("Move")
		return
		
	var collider = owner.PushCast.get_collider()
	if collider.is_in_group("PushBlock"):
		collider.Push(owner)
				
	owner.CharMesh.LerpMeshOrientation(-WallNormal, _delta)
	owner.SetVelocity(inputVel * PUSH_SPEED * _delta)


func UpdateWallNormal() -> bool:
	if !owner.PushCast.is_colliding():
		return false
	
	WallNormal = owner.PushCast.get_collision_normal()
	return true
