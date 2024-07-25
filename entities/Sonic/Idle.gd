extends BasicState



func Enter(_msg := {}) -> void:
	owner.AnimTree.set("parameters/Movement/blend_amount", 0.0)
	owner.AnimTree.set("parameters/Ground/blend_amount", 0.0)
	owner.AnimTree.set("parameters/GroundSecondary/blend_amount", -1.0)
	owner.AnimTree.set("parameters/Idle/blend_amount", 0.0)
	
	owner.SetVelocity(Vector3.ZERO)
	

func Exit() -> void:
	pass


func Update(_delta: float) -> void:
	owner.Move()
	owner.apply_floor_snap()
	
	owner.GroundCollision = owner.CollisionDetection(0, 0)
	
	owner.CharMesh.AlignToY(owner.up_direction)
	
	owner.CharGroundCast.target_position = -(owner.FloorNormal.normalized()) * owner.CharGroundCastLength
	owner.up_direction = owner.FloorNormal
	
	if !owner.GroundCollision or owner.up_direction.dot(Vector3.UP) < owner.PARAMETERS.IDLE_MIN_GROUND_ANGLE:
		ChangeState("Fall", {
		})
		return
	
	if Input.is_action_just_pressed("Jump"):
		ChangeState("Jump", {
		})
		return
	
	if Input.is_action_just_pressed("Attack"):
		ChangeState("SquatCharge")
		return
	
	if owner.GetInputVector().length() > 0.0:
		ChangeState("Walk", {
		})
		return
