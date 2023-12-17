extends "res://entities/Collectible/Collectible.gd"



const Frames = [
	Vector2(0.0, 0.0),
	Vector2(0.25, 0.0),
	Vector2(0.5, 0.0),
	Vector2(0.75, 0.0),
	Vector2(0.0, 0.5),
	Vector2(0.25, 0.5),
	Vector2(0.5, 0.5),
]
var CurrentFrame := 0
var FrameLife := 0.0

const ANIM_SPEED = 1.25

@onready var mat : Material = $Billboard.get_surface_override_material(0)
@onready var FrameTime := 1.0 / Frames.size()


func _physics_process(delta: float) -> void:
	mat.set_shader_parameter("uv_offset", Frames[CurrentFrame])
	
	FrameLife += delta * ANIM_SPEED
	if FrameLife >  FrameTime:
		FrameLife -=  FrameTime
		CurrentFrame += 1
		if CurrentFrame >= Frames.size():
			CurrentFrame = 0


func _on_body_entered(body: Node3D) -> void:
	super(body)
	body.AddCoin()
