extends BasicState


var shadow = null


func Enter(_msg := {}) -> void:
	shadow = owner.SpotShadow
	owner.remove_child(shadow)
	owner.CharMesh.visible = false
	owner.set_collision_layer_value(4, false)
	owner.HurtBox.set_collision_layer_value(8, false)
	$Timer.start()


func Exit() -> void:
	owner.add_child(shadow)
	owner.CharMesh.visible = true
	owner.set_collision_layer_value(4, true)
	owner.HurtBox.set_collision_layer_value(8, true)


func Update(_delta: float) -> void:
	pass


func _on_timer_timeout() -> void:
	ChangeState("Idle")
