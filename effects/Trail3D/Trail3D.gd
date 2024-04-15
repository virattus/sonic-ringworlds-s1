class_name Trail3D
extends MeshInstance3D

#Based on KindoSaur's video at https://youtu.be/vKrrxKS-lcA


@export var Active := true

@export var WidthStart := 1.0
@export var WidthEnd := 0.0
@export_range(0.5, 1.5) var WidthScale := 1.0

@export var Lifetime := 1.0
@export var UpdateRate := 0.1

@export var ColourStart := Color.WHITE
@export var ColourEnd := Color.BLUE


var Points = []
var Widths = []
var Lifetimes = []

var OldPosition := Vector3.ZERO


func _ready() -> void:
	OldPosition = global_position


func _process(delta: float) -> void:
	if Active and (OldPosition - global_position).length() > UpdateRate:
		AddPoint()
		OldPosition = global_position
	
	var it := 0
	var max_points = Points.size()
	while it < max_points:
		Lifetimes[it] -= delta
		if Lifetimes[it] < 0.0:
			RemovePoint(it)
			it -= 1
			if it < 0:
				it = 0
			
		max_points = Points.size()
		it += 1
		
	mesh.clear_surfaces()
	if Points.size() < 2:
		return
	
	mesh.surface_begin(Mesh.PRIMITIVE_TRIANGLE_STRIP)
	for i in range(Points.size()):
		var t = float(i) / (Points.size() - 1.0)
		var CurrentColour = ColourStart.lerp(ColourEnd, 1.0 - t)
		mesh.surface_set_color(CurrentColour)
		
		var CurrentWidth = Widths[i][0] - pow(1.0 - t, WidthScale) * Widths[i][1]
		
		var t0 = i / Points.size()
		var t1 = t
		
		mesh.surface_set_uv(Vector2(t0, 0))
		mesh.surface_add_vertex(to_local(Points[i] + CurrentWidth))
		mesh.surface_set_uv(Vector2(t1, 1))
		mesh.surface_add_vertex(to_local(Points[i] - CurrentWidth))
	mesh.surface_end()
		


func AddPoint() -> void:
	Points.append(global_position)
	Widths.append([
		global_transform.basis.x * WidthStart, 
		(global_transform.basis.x * WidthStart) - (global_transform.basis.x * WidthEnd)
		])
	Lifetimes.append(Lifetime)


func RemovePoint(iter: int) -> void:
	Points.remove_at(iter)
	Widths.remove_at(iter)
	Lifetimes.remove_at(iter)
	
