extends BasicState




func Enter(_msg := {}) -> void:
	owner.CharMesh.visible = false
	owner.SpotShadow.visible = false
	owner.WorldCollision.disabled = true


func Exit() -> void:
	owner.CharMesh.visible = true
	owner.SpotShadow.visible = true
	owner.WorldCollision.disabled = false


func Update(_delta: float) -> void:
	pass


func _on_timer_timeout() -> void:
	ChangeState("Idle")
