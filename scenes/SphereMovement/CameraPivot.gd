extends Node3D


@export var target : Node3D


const ROTATION_AMOUNT = -1.0


func _ready() -> void:
	assert(target)


func _physics_process(delta: float) -> void:
	
	global_position = target.global_position
	
	var rot := 0.0
	
	if Input.is_action_pressed("Camera_Left"):
		rot += ROTATION_AMOUNT * delta
	elif Input.is_action_pressed("Camera_Right"):
		rot -= ROTATION_AMOUNT * delta
	
	
	rotate_y(rot)
