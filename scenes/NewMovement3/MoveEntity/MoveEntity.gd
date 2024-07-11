extends CharacterBody3D



@onready var GroundCast = $GroundCast

const GRAVITY = 9.8
const JUMP_POWER = 8.0


func _ready() -> void:
	pass


func _physics_process(delta: float) -> void:
	if velocity.length() > 0.0:
		$Mesh.look_at(global_position + velocity.normalized())
