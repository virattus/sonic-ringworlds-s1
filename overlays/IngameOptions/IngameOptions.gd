extends CanvasLayer


func _ready():
	$ChkInvertCamera.button_pressed = Globals.InvertCamera


func _input(event):
	if event.is_action_pressed("Pause"):
		visible = !visible
		get_tree().paused = visible


func _on_chk_invert_camera_toggled(toggled_on):
	Globals.InvertCamera = toggled_on
