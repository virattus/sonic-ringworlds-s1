extends Area3D


@export var SpringPower := 10.0
@export var ResetVelocity := false

@onready var UpDirection = global_transform.basis.y


func _on_body_entered(body: Node3D) -> void:
	$sndBounce.stop()
	$sndBounce.play()
	body.StateM.ChangeState("Jump", {
		"JumpForce": SpringPower,
		"IgnoreVel": ResetVelocity,
		"JumpDirection": UpDirection,
		"JumpSound": false,
	})
	
