extends BasicState


var LockMovement := false



func Enter(_msg := {}) -> void:
	owner.AnimTree.set("parameters/Movement/blend_amount", -1.0)
	owner.AnimTree.set("parameters/Hang/blend_amount", 0.0)
	owner.AnimTree.set("parameters/OSHang/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
	
	if _msg.has("LockMovement"):
		LockMovement = _msg["LockMovement"]
	
	


func Exit() -> void:
	owner.AnimTree.set("parameters/OSHang/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_ABORT)
	LockMovement = false


func Update(_delta: float) -> void:
	
	
	
	if Input.is_action_just_released("Jump"):
		ChangeState("Fall")
		return
