extends Area3D


var target = null


func _ready() -> void:
	$MeshInstance3D.scale = scale
	
	var lavaShape = BoxShape3D.new()
	lavaShape.size = scale
	$CollisionShape3D.shape = lavaShape
	$StaticBody3D/CollisionShape3D.shape = lavaShape
	scale = Vector3.ONE
	
	DebugMenu.AddMonitor(self, "target")


func _physics_process(delta: float) -> void:
	if target:
		target.DamageReceived(Vector3.DOWN, 3)



func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("Character"):
		target = body
	elif body.is_in_group("RingBounce"):
		body.gravity_scale = 0.5
		body.linear_velocity = Vector3.ZERO
		body.set_collision_mask_layer(1, false)


func _on_body_exited(body: Node3D) -> void:
	if body == target:
		target = null
