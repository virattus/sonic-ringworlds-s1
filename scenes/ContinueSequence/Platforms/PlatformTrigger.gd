extends Area3D


signal CreatePlatforms(pos: Vector3)

var GeneratedPlatforms := false


func _on_body_entered(body: Node3D) -> void:
	if GeneratedPlatforms:
		return
		
	CreatePlatforms.emit(global_position)
	GeneratedPlatforms = true
