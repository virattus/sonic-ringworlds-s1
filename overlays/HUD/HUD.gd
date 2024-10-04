extends CanvasLayer


@export var CurrentPlayer : Player


@onready var lblSpeed = $LblSpeed


func _process(_delta: float) -> void:
	if !CurrentPlayer:
		return
	
	#UpdateDashModeMeter(_delta)
	lblSpeed.text = "Speed: " + str(roundf(CurrentPlayer.Speed)) 
	$LblRings.text = str(Globals.RingCount)
	$LblLives.text = "Lives: " + str(Globals.LivesCount)


func UpdateDashModeMeter(_delta: float) -> void:
	$StrikeDashMeterBG/StrikeDashMeter.scale.x = clamp(CurrentPlayer.DashModeCharge, 0.0, 1.0)
	$StrikeDashMeterBG/LblStrikeDashPercentage.text = str(clamp(int(CurrentPlayer.DashModeCharge * 100.0), 0, 100)) + "%"


func ActivateFlickyIcon(FlickyID: int) -> void:
	$FlickyStack.ActivateIcon(FlickyID)
