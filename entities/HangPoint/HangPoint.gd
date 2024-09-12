extends Area3D


@export var MovementAxis := Vector3.ZERO


func _on_body_entered(body: Node3D) -> void:
	body.CanHang = true
	body.HangMovementAxis = MovementAxis
	


func _on_body_exited(body: Node3D) -> void:
	body.CanHang = false
