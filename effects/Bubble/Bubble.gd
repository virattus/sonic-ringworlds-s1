extends Sprite3D


var JitterAccumulator := 0.0

var MaxHeight := 0.0

var JitterVel := Vector3.ZERO


func _physics_process(delta: float) -> void:
	if global_position.y > MaxHeight:
		queue_free()
	
	JitterAccumulator -= delta
	if JitterAccumulator < 0.0:
		SetJitterVel()
		JitterAccumulator = randf() + 0.1
	
	global_position += JitterVel * delta
	


func SetJitterVel() -> void:
	JitterVel.x = 1.0 - (randf() * 2.0)
	JitterVel.z = 1.0 - (randf() * 2.0)
	JitterVel.y = 1.0
