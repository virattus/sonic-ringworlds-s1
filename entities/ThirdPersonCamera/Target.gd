extends BasicState


var TargetNode : Node3D


func Enter(_msg := {}) -> void:
	if _msg.has("Target"):
		TargetNode = _msg["Target"]


func Exit() -> void:
	pass


func Update(_delta: float) -> void:
	var targetPos = TargetNode.global_position
	var pos = owner.global_position
	
	owner.UpdateRotation()
