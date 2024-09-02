extends Node3D


var Accumulator := 0.0


func _physics_process(delta: float) -> void:
	if scale.y <= 0.0:
		queue_free()
		
	scale.y = sin(Accumulator)
	
	Accumulator += delta
