extends CanvasLayer


@export var Sonic : Node3D


func _process(_delta: float) -> void:
	$StrikeDashMeterBG/StrikeDashMeter.scale.x = clamp(Sonic.DashModeCharge, 0.0, 1.0)
	$StrikeDashMeterBG/LblStrikeDashPercentage.text = str(clamp(int(Sonic.DashModeCharge * 100.0), 0, 100)) + "%"
	$LblSpeed.text = "Speed: " + str(roundf(Sonic.Speed)) 
	$LblRings.text = "Rings\n" + str(Globals.RingCount)
