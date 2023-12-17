extends ColorRect



signal IrisWipeComplete


var Accumulator := 0.0
var Speed := 1.0
var Direction := 1.0

const WIPE_MODIFIER = 2.2


func _process(delta: float) -> void:
	get_material().set_shader_parameter("WipeRange", WIPE_MODIFIER * clamp(Accumulator / Speed, 0.0, 1.0))
	Accumulator += Direction * delta
		
	if abs(Accumulator) >= Speed:
		IrisWipeComplete.emit()
		queue_free()



func WipeIn(length: float) -> void:
	Speed = length
	Accumulator = 0.0
	Direction = 1.0


func WipeOut(length: float) -> void:
	Speed = length
	Accumulator = Speed
	Direction = -1.0

