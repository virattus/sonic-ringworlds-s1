extends "res://scenes/SphereMovement/TestChar/Air.gd"




func Enter(_msg := {}) -> void:
	owner.GroundCollision = false
	owner.velocity += owner.up_direction * owner.JUMP_POWER


func Exit() -> void:
	pass


func Update(_delta: float) -> void:
	var IsColliding = owner.move_and_slide()

	ApplyGravity(_delta)
	
	if IsColliding:
		ChangeState("Idle")
		return

	ApplyDrag(_delta)
