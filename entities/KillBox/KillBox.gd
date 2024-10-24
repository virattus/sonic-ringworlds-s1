extends Area3D


@export var Active := true


func _on_body_entered(body: Node3D) -> void:
	if !Active:
		return
	
	assert(body.is_in_group("Player"))
	if !body.Invincible:
		body.Kill()


func _on_body_exited(body: Node3D) -> void:
	if !Active:
		return
	
	assert(body.is_in_group("Player"))
	if !body.Invincible:
		body.Kill()
