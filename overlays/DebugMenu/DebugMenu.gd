extends CanvasLayer


@onready var DebugMaster = $DebugMaster
@onready var SceneList = $DebugMaster/TabContainer/Scenes/ItmLstScenes
@onready var MonitorTree = $DebugMaster/TabContainer/Monitors/MonitorTree
@onready var MonitorOverlay = $MonitorOverlay


func _ready() -> void:
	if OS.is_debug_build():
		SetVisibility(false)
	else:
		SetVisibility(false)
	
	for i in Globals.DEBUG_SCENES.keys():
		SceneList.add_item(i)


func _process(_delta: float) -> void:
		if Input.is_action_just_pressed("DEBUG_Toggle") and OS.is_debug_build():
			SetVisibility(!DebugMaster.visible)


func SetVisibility(_visibility : bool) -> void:
	DebugMaster.visible = _visibility
	get_tree().paused = _visibility


func AddMonitor(object, property, display = "") -> void:
	MonitorTree.AddMonitor(object, property, display)


func RemoveMonitor(object, property) -> void:
	MonitorTree.RemoveMonitor(object, property)
	MonitorOverlay.RemoveMonitor(object, property)


func _on_itm_lst_scenes_item_activated(index: int) -> void:
	Globals.CurrentScene = Globals.DEBUG_SCENES[SceneList.get_item_text(index)]
	SetVisibility(false)
	var _error = get_tree().change_scene_to_file(Globals.CurrentScene)


func ToggleDebug(button_pressed: bool, groupName: String) -> void:
	var nodes = get_tree().get_nodes_in_group(groupName)
	for i in nodes:
		i.visible = button_pressed


func _on_chk_show_monitors_toggled(button_pressed: bool) -> void:
	MonitorOverlay.visible = button_pressed
