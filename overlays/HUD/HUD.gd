extends CanvasLayer


@export var Sonic : Node3D


@onready var lblSpeed = $LblSpeed


func _process(_delta: float) -> void:
	UpdateDashModeMeter(_delta)
	lblSpeed.text = "Speed: " + str(roundf(Sonic.Speed)) 
	$LblRings.text = str(Globals.RingCount)
	$LblLives.text = "Lives: " + str(Globals.LivesCount)


func UpdateDashModeMeter(_delta: float) -> void:
	$StrikeDashMeterBG/StrikeDashMeter.scale.x = clamp(Sonic.DashModeCharge, 0.0, 1.0)
	$StrikeDashMeterBG/LblStrikeDashPercentage.text = str(clamp(int(Sonic.DashModeCharge * 100.0), 0, 100)) + "%"
