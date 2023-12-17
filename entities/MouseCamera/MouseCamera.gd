extends Node3D


@export var MouseSensitivity := Vector2(1.0, 1.0)

@onready var vert : Node3D = $Vert
@onready var camera : Camera3D = $Vert/Camera3D

const MOUSE_ADJUST = -0.001
const MAX_ROT_VERT = 89.0


func _ready() -> void:
	pass


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		RotateCamera(event.relative)


func RotateCamera(relativeRot : Vector2) -> void:
	var h = relativeRot.x * MouseSensitivity.x * MOUSE_ADJUST
	var v = relativeRot.y * MouseSensitivity.y * MOUSE_ADJUST
	
	rotate_y(h)
	vert.rotate_x(v)
	
	vert.rotation_degrees.x = clamp(vert.rotation_degrees.x, -MAX_ROT_VERT, MAX_ROT_VERT)


func GetCamera() -> Camera3D:
	return camera


func LookAt(target : Vector3) -> void:
	look_at(target * Vector3(1, 0, 1), Vector3.UP)
	vert.look_at(target * Vector3(0, 1, 0), Vector3.UP)
