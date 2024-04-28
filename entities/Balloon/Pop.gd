extends BasicState




func Enter(_msg := {}) -> void:
	owner.CharMesh.visible = false
	owner.SpotShadow.visible = false
	owner.set_collision_layer_value(4, false)


func Exit() -> void:
	owner.CharMesh.visible = true
	owner.SpotShadow.visible = true
	owner.set_collision_layer_value(4, true)


func Update(_delta: float) -> void:
	pass


func _on_timer_timeout() -> void:
	ChangeState("Idle")
