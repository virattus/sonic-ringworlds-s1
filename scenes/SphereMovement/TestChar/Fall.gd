extends "res://scenes/SphereMovement/TestChar/Air.gd"




func Enter(_msg := {}) -> void:
	owner.GroundCollision = false


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

	ApplyGravity(_delta)
	ApplyDrag(_delta)

	owner.velocity += owner.GetInputVector()
