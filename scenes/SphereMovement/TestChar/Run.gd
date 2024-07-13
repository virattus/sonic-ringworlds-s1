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
	
	
	var newVel = owner.GetInputVector()
	
	if newVel.length() <= 0.0:
		ChangeState("Idle")
		return
		
	owner.velocity += newVel * _delta * 20.0
