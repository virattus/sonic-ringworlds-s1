extends Node2D


func _ready() -> void:
	Input.add_joy_mapping("03000000c82d00001d30000011010000,8BitDo Ultimate 2C,a:b0,b:b1,back:b10,dpdown:h0.4,dpleft:h0.8,dpright:h0.2,dpup:h0.1,guide:b12,leftshoulder:b6,leftstick:b13,lefttrigger:a5,leftx:a0,lefty:a1,paddle1:b5,paddle2:b2,rightshoulder:b7,rightstick:b14,righttrigger:a4,rightx:a2,righty:a3,start:b11,x:b3,y:b4,platform:Linux,", true)


func _physics_process(delta: float) -> void:
	get_tree().change_scene_to_file("res://scenes/MovementTesting/MovementTesting.tscn")
	
