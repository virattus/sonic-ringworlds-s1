extends Control


@export var controller: CharController
@export var character: Character 

@onready var immed = $MeshInstance2D.mesh

func _process(delta: float) -> void:
	$Input.position = controller.InputAnalogue * 50.0
	$Input2.position = Vector2(controller.InputVelocity.x, controller.InputVelocity.z) * 50.0
	
	immed.clear_surfaces()
	immed.surface_begin(Mesh.PRIMITIVE_LINES)
	immed.surface_set_color(Color.RED)
	immed.surface_add_vertex(Vector3(0, 0, 0))
	immed.surface_add_vertex(Vector3($Input.position.x, $Input.position.y, 0.0))
	immed.surface_set_color(Color.GREEN)
	immed.surface_add_vertex(Vector3(0, 0, 0))
	immed.surface_add_vertex(Vector3($Input2.position.x, $Input2.position.y, 0.0))
	immed.surface_end()
