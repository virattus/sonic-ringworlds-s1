class_name Collectible
extends Area3D


signal Collected(body)



func _on_body_entered(body: Node3D) -> void:
	Collected.emit(body)
	queue_free()
