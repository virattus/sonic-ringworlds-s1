extends Sprite3D

@export var StartingScale := 1.0

var Accumulator := 0

const FRAME_TOTAL = 10


func _ready() -> void:
	scale = Vector3.ONE * StartingScale


func _physics_process(delta: float) -> void:
	if Accumulator > FRAME_TOTAL:
		queue_free()
	
	scale = Vector3.ONE * StartingScale * (1.0 - (float(Accumulator) / float(FRAME_TOTAL)))
	Accumulator += 1
	
	
