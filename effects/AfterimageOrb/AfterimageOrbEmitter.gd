extends Node3D


@export var SceneRoot : Node3D

@export var Active := true

@export var SpawnRate := 0.0333

@export var Size := 1.0
@export var Colour := Color.WHITE


var SpawnRateAccumulator := 0.0


const ORB = preload("res://effects/AfterimageOrb/AfterimageOrb.tscn")

func _physics_process(delta: float) -> void:
	if !Active:
		return
	
	if SpawnRateAccumulator > SpawnRate:
		SpawnRateAccumulator -= SpawnRate
		SpawnOrb()
	
	SpawnRateAccumulator += delta
	
	
func SpawnOrb() -> void:
	var newOrb = ORB.instantiate()
	newOrb.StartingScale = Size
	newOrb.modulate = Colour
	SceneRoot.get_parent().add_child(newOrb)
	newOrb.global_position = global_position
