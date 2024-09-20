extends CanvasLayer


func _ready():
	GetCameraSettings()


func _input(event):
	if event.is_action_pressed("Pause"):
		visible = !visible
		get_tree().paused = visible


func SetCameraSettings(null_value) -> void:
	if !visible:
		return
		
	Globals.CameraSensitivity.x = ($CameraSettings/hsCamX.value / 100.0) * (-1.0 if $CameraSettings/chkInvertCamX.button_pressed else 1.0)
	Globals.CameraSensitivity.y = ($CameraSettings/hsCamY.value / 100.0) * (-1.0 if $CameraSettings/chkInvertCamY.button_pressed else 1.0)


func GetCameraSettings() -> void:
	if !visible:
		return
		
	$CameraSettings/hsCamX.value = int(abs(Globals.CameraSensitivity.x) * 100)
	$CameraSettings/hsCamY.value = int(abs(Globals.CameraSensitivity.y) * 100)

	$CameraSettings/chkInvertCamX.button_pressed = signf(Globals.CameraSensitivity.x) == -1.0
	$CameraSettings/chkInvertCamY.button_pressed = signf(Globals.CameraSensitivity.y) == -1.0
	
