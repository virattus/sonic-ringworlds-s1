extends BasicState



func Enter(_msg := {}) -> void:
	owner.AnimTree.set("parameters/Movement/blend_amount", 0.0)
	owner.AnimTree.set("parameters/Ground/blend_amount", 0.0)
	owner.AnimTree.set("parameters/GroundSecondary/blend_amount", -1.0)
	owner.AnimTree.set("parameters/Idle/blend_amount", 0.0)
	

func Exit() -> void:
	pass


func Update(_delta: float) -> void:
	
	if !owner.CheckGroundCollision():
		ChangeState("Fall")
		return
	
	if Input.is_action_just_pressed("Jump"):
		ChangeState("Jump")
		return
	
	if Input.is_action_just_pressed("Attack"):
		ChangeState("SquatCharge")
		return
	
	if owner.Controller.InputVelocity.length() > 0.0:
		ChangeState("Move")
		return
		
	
	owner.UpdateUpDir()
	owner.CharGroundCast.target_position = -(owner.FloorNormal.normalized())
	owner.CheckCharGroundCast()
	owner.CharMesh.AlignToY(owner.up_direction)
	owner.Move(Vector3.ZERO)
	
