extends BasicState



func Enter(_msg := {}) -> void:
	owner.AnimTree.set("parameters/Movement/blend_amount", 0.0)
	owner.AnimTree.set("parameters/Ground/blend_amount", 1.0)
	owner.AnimTree.set("parameters/GroundSecondary/blend_amount", -1.0)
	owner.AnimTree.set("parameters/Run/blend_amount", 1.0)


func Exit() -> void:
	pass


func Update(_delta: float) -> void:
	var vel = (owner.Controller.InputVelocity) * 10.0
	
	owner.Move(vel)
	owner.CharMesh.look_at(owner.global_position + owner.velocity.normalized())

	if !owner.is_on_floor():
		ChangeState("Fall")
		return
