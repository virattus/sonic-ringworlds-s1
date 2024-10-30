extends Node3D


@export var BoostTime := 0.1
@export var BoostForce := 1.0


func _on_area_3d_body_entered(body: Node3D) -> void:
	#$SndBooster.play()
	#body.SetVelocity(-global_transform.basis.z * BoostForce)
	#body.TrueVelocity = (-global_transform.basis.z * BoostForce)
	body.BounceVelocity = Vector3.ZERO
	body.CharMesh.global_transform.basis = global_transform.basis
	body.StateM.ChangeState("Move", {
		"Boost": -global_transform.basis.z * BoostForce,
		"IgnoreInput": 0.5,
		#"UpdateModelOrientation": true,
	})
