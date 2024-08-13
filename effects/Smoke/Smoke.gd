extends Sprite3D


var Accumulator := 0.0


func _physics_process(delta: float) -> void:
	global_position.y += Accumulator * delta
	scale = Vector3.ONE * (1.0 + (Accumulator * 3.0))
	
	modulate.a = clamp(1.0 - Accumulator, 0.0, 1.0)
	if modulate.a <= 0.0:
		queue_free()
	
	Accumulator += delta
