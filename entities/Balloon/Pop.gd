extends BasicState


var shadow = null

var Accumulator := 0.0


func Enter(_msg := {}) -> void:
	Accumulator = 0.0
	shadow = owner.SpotShadow
	owner.remove_child(shadow)
	owner.CharMesh.visible = false
	owner.SpritePop.visible = true
	owner.set_collision_layer_value(4, false)
	owner.HurtBox.set_collision_layer_value(8, false)
	$Timer.start()


func Exit() -> void:
	owner.add_child(shadow)
	owner.CharMesh.visible = true
	owner.set_collision_layer_value(4, true)
	owner.HurtBox.set_collision_layer_value(8, true)


func Update(_delta: float) -> void:
	owner.SpritePop.scale = Vector3.ONE * (1.0 + Accumulator)
	Accumulator += _delta
	if Accumulator >= 0.25:
		owner.SpritePop.visible = false


func _on_timer_timeout() -> void:
	ChangeState("Idle")
