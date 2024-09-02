extends Area3D


const AUDIO_BUS_SF = 2
const AUDIO_EFF_REVERB = 0

const WATER_SPLASH = preload("res://effects/WaterSplash/WaterSplash.tscn")


func _ready() -> void:
	$MeshInstance3D.scale = scale
	$CollisionShape3D.shape = BoxShape3D.new()
	$CollisionShape3D.shape.size = scale
	scale = Vector3.ONE


func _on_body_entered(body: Node3D) -> void:
	body.IsUnderwater = true
	CreateSplash(body.global_position)
	AudioServer.set_bus_effect_enabled(AUDIO_BUS_SF, AUDIO_EFF_REVERB, true)



func _on_body_exited(body: Node3D) -> void:
	body.IsUnderwater = false
	CreateSplash(body.global_position)
	AudioServer.set_bus_effect_enabled(AUDIO_BUS_SF, AUDIO_EFF_REVERB, false)



func CreateSplash(pos: Vector3) -> void:
	var splash = WATER_SPLASH.instantiate()
	
	get_parent().add_child(splash)
	splash.global_position = pos
