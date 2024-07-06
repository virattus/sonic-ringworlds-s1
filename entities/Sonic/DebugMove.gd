extends BasicState



const MOVE_SPEED = 10.0
const HEIGHT_SPEED = 500.0


func Enter(_msg := {}) -> void:
	pass


func Exit() -> void:
	pass


func Update(_delta: float) -> void:
	if Input.is_action_just_pressed("DEBUG_ResetPosition"):
		owner.DebugMove = false
		owner.global_position = owner.StartingPosition
		owner.Speed = 0.0
		owner.velocity = Vector3.ZERO
		owner.up_direction = Vector3.UP
		owner.FloorNormal = Vector3.UP
		ChangeState("Air", {
			"SubState": "Fall",
		})
	
	var vel = owner.Controller.InputVelocity * MOVE_SPEED
	
	if Input.is_action_pressed("DEBUG_AddHeight"):
		vel.y += HEIGHT_SPEED * _delta
	if Input.is_action_pressed("DEBUG_RemoveHeight"):
		vel.y -= HEIGHT_SPEED * _delta
	
	
	owner.Move(vel)
