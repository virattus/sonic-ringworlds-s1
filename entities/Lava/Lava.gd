extends Area3D




func _ready() -> void:
	$MeshInstance3D.scale = scale
	
	var lavaShape = BoxShape3D.new()
	lavaShape.size = scale
	$CollisionShape3D.shape = lavaShape
	$StaticBody3D/CollisionShape3D.shape = lavaShape
	scale = Vector3.ONE


func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		body.DamageReceived(body.global_position, 3)
	elif body.is_in_group("RingBounce"):
		body.EnteredLava()
