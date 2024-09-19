extends "res://entities/Sonic/MoveAir.gd"


var MeterAccumulator := 0.0

const METER_MAX = 0.30


func Enter(_msg := {}) -> void:
	owner.AnimTree.set("parameters/OSPose/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
	
	owner.UpdateUpDir(Vector3.UP, -1.0)
	
	owner.DashModeCharge += METER_MAX


func Exit() -> void:
	owner.AnimTree.set("parameters/OSPose/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_ABORT)
	owner.CharMesh.look_at(owner.global_position + (owner.velocity * Vector3(1, 0, 1)))


func Update(_delta: float) -> void:
	owner.Move()
	
	var collision : SonicCollision = owner.GetCollision()
	if CheckGroundCollision(collision):
		ChangeState("Land", {
			
		})
		return

	
	var cam = get_viewport().get_camera_3d()
	owner.CharMesh.look_at(-cam.global_transform.origin)
	
	owner.CharMesh.AlignToY(owner.up_direction)
	owner.UpdateUpDir(Vector3.UP, _delta)
	
	if !owner.AnimTree.get("parameters/OSPose/active"):
		ChangeState("Fall")
		return

	OldVel = owner.velocity
