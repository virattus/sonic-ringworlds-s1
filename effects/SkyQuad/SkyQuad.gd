extends MeshInstance3D


#if we're going to do stuff with multiple cameras, the easiest thing is just to 
#get the camera every frame
@export var OffsetMultiplier = Vector2(-3.0, -0.2)

var UVOffset := Vector2.ZERO


func _ready() -> void:
	DebugMenu.AddMonitor(self, "UVOffset")


func _process(_delta: float) -> void:
	var camTransform = get_viewport().get_camera_3d().global_transform
	global_position = camTransform.origin - camTransform.basis.z
	
	var camBasis : Vector3 = camTransform.basis.get_euler()
	var t = (((camBasis / PI) + Vector3(1.0, 1.0, 1.0)) / 2.0)
	UVOffset = Vector2(t.y * OffsetMultiplier.x, t.x * OffsetMultiplier.y)
	get_surface_override_material(0).set("shader_parameter/uv_offset", UVOffset)
