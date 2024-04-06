extends Control


@onready var chkFullscreen = $ChkFullscreen
@onready var btnFPS = $BtnFPS
@onready var obVsync = $LblVsync/OBVsync


func _ready() -> void:
	btnFPS.text = "FPS: " + str(Engine.physics_ticks_per_second)
	obVsync.selected = DisplayServer.window_get_vsync_mode()
	chkFullscreen.button_pressed = DisplayServer.window_get_mode() >= 3


func _on_chk_fullscreen_toggled(button_pressed: bool) -> void:
	var mode = DisplayServer.WINDOW_MODE_FULLSCREEN
	if button_pressed == false:
		mode = DisplayServer.WINDOW_MODE_WINDOWED
		DisplayServer.window_set_size(Globals.WindowedModeScreenSize, 0)
	
	var windows : PackedInt32Array = DisplayServer.get_window_list()
	if windows.size() == 1:
		DisplayServer.window_set_mode(mode, windows[0])
		DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, button_pressed, windows[0])
		#print(DisplayServer.screen_get_size(0))
	else:
		printerr("Unimplemented: fullscreen with multiple windows")


func _on_ob_vsync_item_selected(index: int) -> void:
	DisplayServer.window_set_vsync_mode(index)


func _on_btn_fps_pressed() -> void:
	var currentFPS = Engine.physics_ticks_per_second
	if currentFPS == 240:
		currentFPS = 15
	else:
		if currentFPS == 15:
			currentFPS += 15
		else:
			currentFPS += 30
	
	btnFPS.text = "FPS: " + str(currentFPS)
	Engine.physics_ticks_per_second = currentFPS
