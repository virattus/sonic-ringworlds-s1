extends CanvasLayer


@export var Sonic : Node3D


func _process(delta: float) -> void:
	#$StrikeDashMeterBG/StrikeDashMeter.scale.x = Sonic.StrikeDashMeter
	$LblSpeed.text = "Speed: " + str(roundf(Sonic.Speed)) 
	$LblRings.text = "Rings\n" + str(Globals.RingCount)
