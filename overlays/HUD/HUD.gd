extends CanvasLayer


@export var Sonic : Node3D


@onready var lblSpeed = $LblSpeed


func _process(_delta: float) -> void:
	$StrikeDashMeterBG/StrikeDashMeter.scale.x = clamp(Sonic.DashModeCharge, 0.0, 1.0)
	$StrikeDashMeterBG/LblStrikeDashPercentage.text = str(clamp(int(Sonic.DashModeCharge * 100.0), 0, 100)) + "%"
	lblSpeed.text = "Speed: " + str(roundf(Sonic.Speed)) 
	$LblRings.text = "Rings\n" + str(Globals.RingCount)
