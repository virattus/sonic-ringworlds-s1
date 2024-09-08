extends Node3D


@export var BoostTime := 0.1
@export var BoostForce := 1.0


func _on_area_3d_body_entered(body: Node3D) -> void:
	$SndBooster.play()
	body.SetVelocity(-global_transform.basis.z * BoostForce)
	body.CharMesh.global_transform.basis = global_transform.basis
	return
	
	body.StateM.ChangeState("Move", {
		"IgnoreInput": BoostTime,
		"Boost": -global_transform.basis.z * BoostForce,
	})
