extends BasicState




func Enter(_msg := {}) -> void:
	owner.AnimTree.set("parameters/Movement/blend_amount", 1.0)
	owner.AnimTree.set("parameters/OSPose/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
	
	owner.FloorNormal = Vector3.UP


func Exit() -> void:
	owner.AnimTree.set("parameters/OSPose/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_ABORT)


func Update(_delta: float) -> void:
	
	
	owner.CharMesh.AlignToY(owner.up_direction)
	owner.up_direction = owner.up_direction.slerp(owner.FloorNormal.normalized(), _delta * owner.UP_VEC_LERP_RATE).normalized()
	
	if !owner.AnimTree.get("parameters/OSPose/active"):
		ChangeState("Fall")
		return
