extends Node3D


@export var SonicNode: Character
@export var FrameCount := 5


var RecordedData = []

@onready var anim_player = $AfterImage/Sonic_Afterimage/AnimationPlayer


func _ready() -> void:
	anim_player.play("StrikeDash")



func _physics_process(delta: float) -> void:
	visible = SonicNode.DashMode
	
	#if visible:
	#	var player = SonicNode.get_node(SonicNode.AnimTree.anim_player)
	#	if player != null:
	#		var anim = player.current_animation
	#		if anim != null and anim != anim_player.current_animation:
	#			anim_player.play(anim)
	
	RecordedData.push_front(SonicNode.CharMesh.global_transform)
	
	if RecordedData.size() > FrameCount:
		$AfterImage.global_transform = RecordedData.back()
		RecordedData.pop_back()
	


