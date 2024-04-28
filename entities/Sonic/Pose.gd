extends BasicState


var MeterAccumulator := 0.0

const METER_MAX = 0.30


func Enter(_msg := {}) -> void:
	owner.AnimTree.set("parameters/Movement/blend_amount", 1.0)
	owner.AnimTree.set("parameters/OSPose/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
	
	owner.FloorNormal = Vector3.UP
	
	owner.DashModeCharge += METER_MAX


func Exit() -> void:
	owner.AnimTree.set("parameters/OSPose/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_ABORT)
	owner.CharMesh.look_at(owner.global_position + (owner.velocity * Vector3(1, 0, 1)))


func Update(_delta: float) -> void:
	
	var cam = get_viewport().get_camera_3d()
	owner.CharMesh.look_at(-cam.global_transform.origin)
	
	owner.CharMesh.AlignToY(owner.up_direction)
	owner.up_direction = owner.up_direction.slerp(owner.FloorNormal.normalized(), _delta * owner.UP_VEC_LERP_RATE).normalized()
	
	if !owner.AnimTree.get("parameters/OSPose/active"):
		ChangeSubState("Fall")
		return
