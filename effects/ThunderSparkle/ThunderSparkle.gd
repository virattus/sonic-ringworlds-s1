extends AnimatedSprite3D


@export var Velocity : Vector3
@export var Lifetime := 1.0

const GRAVITY = 9.8

func _physics_process(delta: float) -> void:
	if Lifetime <= 0.0:
		queue_free()
	
	global_translate(Velocity * delta)
	Velocity.y -= GRAVITY * delta
	
	Lifetime -= delta
