extends Node3D


@export var SonicNode: Character
@export var FrameCount := 5


var RecordedData = []


func _ready() -> void:
	$AfterImage/Sonic_Afterimage/AnimationPlayer.play("StrikeDash")


func _physics_process(delta: float) -> void:
	visible = SonicNode.DashMode
	
	RecordedData.push_front(SonicNode.CharMesh.global_transform)
	
	if RecordedData.size() > FrameCount:
		$AfterImage.global_transform = RecordedData.back()
		RecordedData.pop_back()
	


