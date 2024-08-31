extends Area3D


const WATER_SPLASH = preload("res://effects/WaterSplash/WaterSplash.tscn")


func _on_body_entered(body: Node3D) -> void:
	body.IsUnderwater = true
	CreateSplash(body.global_position)


func _on_body_exited(body: Node3D) -> void:
	body.IsUnderwater = false
	CreateSplash(body.global_position)


func CreateSplash(pos: Vector3) -> void:
	var splash = WATER_SPLASH.instantiate()
	
	get_parent().add_child(splash)
	splash.global_position = pos
