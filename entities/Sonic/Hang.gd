extends BasicState


var LockMovement := false



func Enter(_msg := {}) -> void:
	if _msg.has("LockMovement"):
		LockMovement = _msg["LockMovement"]
	
	


func Exit() -> void:
	LockMovement = false


func Update(_delta: float) -> void:
	
	
	if Input.is_action_just_released("Jump"):
		ChangeState("Fall")
		return
