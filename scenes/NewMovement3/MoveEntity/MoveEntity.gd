extends CharacterBody3D


var GroundCollision := false

@onready var GroundCast = $GroundCast

@onready var UpIndicator = $UpIndicator

const GRAVITY = 9.8
const JUMP_POWER = 8.0


func _ready() -> void:
	DebugMenu.AddMonitor(self, "GroundCollision")


func _physics_process(delta: float) -> void:
	if velocity.length() > 0.0:
		$Mesh.look_at(global_position + velocity.normalized())
	
	UpIndicator.position = up_direction
