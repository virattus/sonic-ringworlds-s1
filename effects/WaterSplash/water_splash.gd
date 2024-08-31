extends Sprite3D


var Accumulator := 0.0

const SCALE = Vector3(1.0, 2.0, 1.0)
const SCALE_SPEED = 2.0


func _ready() -> void:
	pass


func _physics_process(delta: float) -> void:
	scale.y = sin(Accumulator)
	
	Accumulator += delta * SCALE_SPEED
	
	if scale.y < 0.0:
		queue_free()
