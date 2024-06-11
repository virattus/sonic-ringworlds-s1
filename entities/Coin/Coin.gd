extends "res://entities/Collectible/Collectible.gd"


func _on_body_entered(body: Node3D) -> void:
	if body.CollectRing():
		super(body)
