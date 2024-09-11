extends Node3D


var Accumulator := 0.0

const SCALE_SPEED = 4.0

func _physics_process(delta: float) -> void:
	Accumulator += SCALE_SPEED * delta
	
	scale.y = sin(Accumulator)
	
	if scale.y <= 0.0:
		queue_free()
