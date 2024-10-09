extends Node3D



@onready var testchar = $TestChar
@onready var path = $Path3D


func _ready() -> void:
	DebugMenu.AddMonitor(testchar, "position")


func _physics_process(delta: float) -> void:
	var horizInput = Input.get_vector("Move_Left", "Move_Right", "Move_Forward", "Move_Backward")
	var vertInput = Input.get_axis("Camera_Down", "Camera_Up")
	var newPos = Vector3(horizInput.x, vertInput, horizInput.y)
	
	testchar.position += newPos * delta
	
	var point = path.curve.get_closest_point(testchar.position)
	
	print(point)
	
	testchar.position = testchar.position.move_toward(point, delta * 0.125)
	
