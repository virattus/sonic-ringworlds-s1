extends BasicState



var VerticalVelocity := 0.0


const BOUNCE_VELOCITY = 10.0


func Enter(_msg := {}) -> void:
	pass


func Exit() -> void:
	VerticalVelocity = 0.0


func Update(_delta: float) -> void:
	owner.Move()
	
	owner.BitParent.rotate_y(_delta)

	var newVel = owner.velocity
	owner.CharMesh.LerpMeshOrientation(-newVel, _delta)
	
	newVel.y -= 10.0 * _delta
	
	if owner.is_on_floor():
		var direction = owner.global_position.direction_to(Globals.PlayerChar.global_position)
		newVel = (direction * Vector3(1, 0, 1)) + (Vector3.UP * BOUNCE_VELOCITY)
	
	owner.SetVelocity(newVel)
