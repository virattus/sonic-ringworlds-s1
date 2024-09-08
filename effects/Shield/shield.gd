extends Node3D


func _physics_process(delta: float) -> void:
	var cam : Camera3D = get_viewport().get_camera_3D()
	
	#look_at(cam.global_position)
	
	
