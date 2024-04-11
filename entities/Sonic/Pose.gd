extends BasicState




func Enter(_msg := {}) -> void:
	owner.AnimTree.set("parameters/Movement/blend_amount", 1.0)
	owner.AnimTree.set("parameters/OSPose/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)


func Exit() -> void:
	owner.AnimTree.set("parameters/OSPose/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_ABORT)


func Update(_delta: float) -> void:
	if !owner.AnimTree.get("parameters/OSPose/active"):
		ChangeState("Fall")
		return
