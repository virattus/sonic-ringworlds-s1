extends "res://entities/MouseCamera/MouseCamera.gd"


var Speed = 5.0


func _process(delta: float) -> void:
	var MoveInput = Vector2(Input.get_axis("Move_Left", "Move_Right"), Input.get_axis("Move_Forward", "Move_Backward"))
	
	var Velocity = (camera.global_transform.basis.z * MoveInput.y) + (camera.global_transform.basis.x * MoveInput.x)
	Velocity = Velocity.normalized()
	
	global_position += Velocity * Speed * delta



func SetActive(_active : bool) -> void:
	camera.current = _active
	
	if _active:
		Globals.PreviousMouseMode = Input.mouse_mode
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	else:
		var mode = Input.mouse_mode
		Input.mouse_mode = Globals.PreviousMouseMode
		Globals.PreviousMouseMode = mode
