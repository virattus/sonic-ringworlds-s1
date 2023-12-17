extends Label



func Update(Pressure: float) -> void:
	$Background/ColorRect.scale.y = Pressure
