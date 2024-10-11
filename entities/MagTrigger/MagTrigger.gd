extends Area3D


@export var Path : Path3D


var TargetBody : Player = null


func _physics_process(delta: float) -> void:
	if !TargetBody:
		return
	
	if !TargetBody.GroundCollision:
		return
	#to_local shenanigans because curves can't understand global coordinates
	var closestPoint = Path.curve.get_closest_point(to_local(TargetBody.global_position))
	var distanceTo = to_local(TargetBody.global_position).distance_to(closestPoint)
	var directionTo = TargetBody.global_position.direction_to(to_global(closestPoint))
	
	#print("this should show something")
	#print("closest point: %s distance to: %s" % [closestPoint, distanceTo])
	
	var targetSpeed = TargetBody.Speed
	TargetBody.SetVelocity((TargetBody.velocity + directionTo).normalized() * targetSpeed)


func _on_body_entered(body: Node3D) -> void:
	TargetBody = body


func _on_body_exited(body: Node3D) -> void:
	TargetBody = null
