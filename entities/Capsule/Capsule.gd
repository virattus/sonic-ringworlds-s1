extends Node3D


signal CapsuleBroken

var IsCapsuleBroken := false


func BreakCapsule() -> void:
	if IsCapsuleBroken:
		return
	
	IsCapsuleBroken = true


func _on_area_3d_body_entered(body: Node3D) -> void:
	$CapsuleButton.position.y = 0.5
	$SndButtonPress.play()
	CapsuleBroken.emit()
	BreakCapsule()


func _on_area_3d_body_exited(body: Node3D) -> void:
	$CapsuleButton.position.y = 0.0
