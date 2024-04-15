class_name CylinderTrail2
extends MeshInstance3D

#Based on Trail3D by miziziziz
#https://github.com/willnationsdev/godot-next/blob/master/addons/godot-next/3d/trail_3d.gd

@export var Active := true
@export var Lifetime := 1.0
@export var UpdateRate = 0.1
@export var MaxRadius := 0.5
@export var density_lengthwise := 25
@export var radial_steps := 6
@export_exp_easing var shape : float
@export var ColourStart := Color.WHITE
@export var ColourEnd := Color.WHITE


var Points = []
var PointsCount := 0
var Lifetimes = []

var OldPosition := Vector3.ZERO


func _ready() -> void:
	DebugMenu.AddMonitor(self, "PointsCount")
	
	if radial_steps < 3:
		radial_steps = 3
	if density_lengthwise < 2:
		density_lengthwise = 2
	
	OldPosition = global_position


func _process(_delta) -> void:
	update_trail(_delta)
	mesh.clear_surfaces()
	if Points.size() > 2:
		render_trail()


func update_trail(_delta: float) -> void:
	if Active and (OldPosition - global_position).length() > UpdateRate:
		AddPoint()
		OldPosition = global_position
	
	var it := 0
	var max_points = Points.size()
	while it < max_points:
		Lifetimes[it] -= _delta
		if Lifetimes[it] < 0.0:
			RemovePoint(it)
			it -= 1
			if it < 0:
				it = 0
			
		max_points = Points.size()
		it += 1
	
	PointsCount = Points.size()


func AddPoint() -> void:
	Points.append(global_position)
	Lifetimes.append(Lifetime)


func RemovePoint(iter: int) -> void:
	Points.remove_at(iter)
	Lifetimes.remove_at(iter)


func render_trail():
	mesh.surface_begin(Mesh.PRIMITIVE_TRIANGLES)
	var local_points = []
	for p in Points:
		local_points.append(p - global_position)
	var last_p = Vector3()
	var verts = []
	var ind = 0
	var first_iteration = true
	var last_first_vec = Vector3()
	# Create vertex loops around points.
	for p in local_points:
		var new_last_points = []
		var offset = last_p - p
		if offset == Vector3():
			continue
		# Get vector pointing from this point to last point.
		var y_vec = offset.normalized()
		var x_vec = Vector3()
		if first_iteration:
			# Cross product with random vector to get a perpendicular vector.
			x_vec = y_vec.cross(y_vec.rotated(Vector3.RIGHT, 0.3))
		else:
			# Keep each loop at the same rotation as the previous.
			x_vec = y_vec.cross(last_first_vec).cross(y_vec).normalized()
		var width = MaxRadius
		#if shape != 0.0:
		#	width = (1 - ease((ind + 1.0) / density_lengthwise, shape)) * MaxRadius
		var seg_verts = []
		var f_iter = true
		for i in range(radial_steps): # Set up row of verts for each level.
			var new_vert = p + width * x_vec.rotated(y_vec, i * TAU / radial_steps).normalized()
			if f_iter:
				last_first_vec = new_vert - p
				f_iter = false
			seg_verts.append(new_vert)
		verts.append(seg_verts)
		last_p = p
		ind += 1
		first_iteration = false
	
	# Create tris.
	for j in range(len(verts) - 1):
		var cur = verts[j]
		var nxt = verts[j + 1]
		
		var t = float(j) / (verts.size() - 1.0)
		var CurrentColour = ColourStart.lerp(ColourEnd, 1.0 - t)
		mesh.surface_set_color(CurrentColour)
		
		for i in range(radial_steps):
			var nxt_i = (i + 1) % radial_steps
			# Order added affects normal.
			mesh.surface_add_vertex(cur[i])
			mesh.surface_add_vertex(cur[nxt_i])
			mesh.surface_add_vertex(nxt[i])
			mesh.surface_add_vertex(cur[nxt_i])
			mesh.surface_add_vertex(nxt[nxt_i])
			mesh.surface_add_vertex(nxt[i])
	
	
#	if verts.size() > 1:
#		# Cap off top.
#		for i in range(density_around):
#			var nxt = (i + 1) % density_around
#			mesh.surface_add_vertex(verts[0][i])
#			mesh.surface_add_vertex(Vector3())
#			mesh.surface_add_vertex(verts[0][nxt])
		
#		# Cap off bottom.
#		for i in range(density_around):
#			var nxt = (i + 1) % density_around
#			mesh.surface_add_vertex(verts[verts.size() - 1][i])
#			mesh.surface_add_vertex(verts[verts.size() - 1][nxt])
#			mesh.surface_add_vertex(last_p)
			
	mesh.surface_end()
