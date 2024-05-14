extends Control


@export var ControllerID = 0


const ButtonPress = Color.RED
const ButtonRelease = Color.WHITE


func _physics_process(delta: float) -> void:
	if !CheckControllerStatus():
		return
	
	$Start.color = ButtonPress if Input.is_joy_button_pressed(ControllerID, JOY_BUTTON_START) else ButtonRelease
	$Back.color = ButtonPress if Input.is_joy_button_pressed(ControllerID, JOY_BUTTON_BACK) else ButtonRelease
	$Guide.color = ButtonPress if Input.is_joy_button_pressed(ControllerID, JOY_BUTTON_GUIDE) else ButtonRelease
	$RBumper.color = ButtonPress if Input.is_joy_button_pressed(ControllerID, JOY_BUTTON_RIGHT_SHOULDER) else ButtonRelease
	$LBumper.color = ButtonPress if Input.is_joy_button_pressed(ControllerID, JOY_BUTTON_LEFT_SHOULDER) else ButtonRelease
	$LStick.color = ButtonPress if Input.is_joy_button_pressed(ControllerID, JOY_BUTTON_LEFT_STICK) else ButtonRelease
	$RStick.color = ButtonPress if Input.is_joy_button_pressed(ControllerID, JOY_BUTTON_RIGHT_STICK) else ButtonRelease
	$A.color = ButtonPress if Input.is_joy_button_pressed(ControllerID, JOY_BUTTON_A) else ButtonRelease
	$B.color = ButtonPress if Input.is_joy_button_pressed(ControllerID, JOY_BUTTON_B) else ButtonRelease
	$X.color = ButtonPress if Input.is_joy_button_pressed(ControllerID, JOY_BUTTON_X) else ButtonRelease
	$Y.color = ButtonPress if Input.is_joy_button_pressed(ControllerID, JOY_BUTTON_Y) else ButtonRelease
	$DU.color = ButtonPress if Input.is_joy_button_pressed(ControllerID, JOY_BUTTON_DPAD_UP) else ButtonRelease
	$DD.color = ButtonPress if Input.is_joy_button_pressed(ControllerID, JOY_BUTTON_DPAD_DOWN) else ButtonRelease
	$DL.color = ButtonPress if Input.is_joy_button_pressed(ControllerID, JOY_BUTTON_DPAD_LEFT) else ButtonRelease
	$DR.color = ButtonPress if Input.is_joy_button_pressed(ControllerID, JOY_BUTTON_DPAD_RIGHT) else ButtonRelease

	$LAnalogue.Update(Vector2(Input.get_joy_axis(ControllerID, JOY_AXIS_LEFT_X), Input.get_joy_axis(ControllerID, JOY_AXIS_LEFT_Y)))
	$RAnalogue.Update(Vector2(Input.get_joy_axis(ControllerID, JOY_AXIS_RIGHT_X), Input.get_joy_axis(ControllerID, JOY_AXIS_RIGHT_Y)))
	$LTrigger.Update(Input.get_joy_axis(ControllerID, JOY_AXIS_TRIGGER_LEFT))
	$RTrigger.Update(Input.get_joy_axis(ControllerID, JOY_AXIS_TRIGGER_RIGHT))
	
	#print($LAnalogue.StickPosition.position)


func CheckControllerStatus() -> bool:
	var controllername = Input.get_joy_name(ControllerID)
	if controllername.is_empty():
		$ControllerName.text = "No Controller Detected"
		$ControllerGUID.text = ""
		return false
	else:
		$ControllerName.text = controllername
		$ControllerGUID.text = Input.get_joy_guid(ControllerID)
		return true
