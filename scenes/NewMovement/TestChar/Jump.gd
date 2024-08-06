extends "res://scenes/NewMovement/TestChar/Air.gd"




func Enter(_msg := {}) -> void:
	owner.GroundCollision = false
	owner.velocity += owner.up_direction * owner.JUMP_POWER


func Exit() -> void:
	pass


func Update(_delta: float) -> void:
	var IsColliding = owner.move_and_slide()

	if IsColliding:
		ChangeState("Land")
		return

	if Input.is_action_just_pressed("Jump"):
		ChangeState("Jump")
		return

	if owner.velocity.y <= 0.0:
		ChangeState("Fall")
		return

	ApplyGravity(_delta)


	ApplyDrag(_delta)
	
	owner.velocity += owner.GetInputVector()
