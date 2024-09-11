extends Area3D


var MaxHeight := 0.0

var CurrentScale := 0.01


const RISE_RATE = 0.6


func _physics_process(delta: float) -> void:
	if global_position.y >= MaxHeight:
		queue_free()
	
	CurrentScale += delta
	
	$BubbleSprite.scale = Vector3.ONE * clamp(CurrentScale, 0.0, 1.0)
	
	#if CurrentScale > 1.0:
	#	$Area3D.monitoring = true
	
	global_position.y += RISE_RATE * delta


func _on_body_entered(body: Node3D) -> void:
	body.BreatheAirBubble()
	queue_free()
