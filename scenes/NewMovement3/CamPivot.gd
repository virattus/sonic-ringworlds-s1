extends Node3D


const CAM_ROTATE_SPEED = 1.0


func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("Camera_Left"):
		rotate_y(CAM_ROTATE_SPEED * delta)
	elif Input.is_action_pressed("Camera_Right"):
		rotate_y(-CAM_ROTATE_SPEED * delta)
	
