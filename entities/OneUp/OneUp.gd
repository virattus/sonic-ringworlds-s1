extends Collectible


func _on_body_entered(body: Node3D) -> void:
	if body.CollectOneUp():
		super(body)
