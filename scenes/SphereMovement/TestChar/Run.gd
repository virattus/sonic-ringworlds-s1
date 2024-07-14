extends "res://scenes/SphereMovement/TestChar/Move.gd"



func Enter(_msg := {}) -> void:
	pass


func Exit() -> void:
	pass


func Update(_delta: float) -> void:
	var IsColliding = owner.move_and_slide()
	owner.apply_floor_snap()
	
	
	if Input.is_action_just_pressed("Jump"):
		ChangeState("Jump")
		return
	
	if !IsColliding:
		ChangeState("Fall")
		return
	
	var newVel = owner.GetInputVector()
		
	owner.velocity += newVel * _delta * 20.0
	
	if owner.velocity.length() <= 0.0:
		ChangeState("Idle")
		return
