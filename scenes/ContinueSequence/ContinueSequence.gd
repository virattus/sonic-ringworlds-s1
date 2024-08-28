extends "res://scenes/SonicGame/SonicGame.gd"


@onready var Player = $Sonic
@onready var Killbox = $KillBox
@onready var Platforms = $Platforms


const MIN_PLATFORM_DIST = 20.0
const MAX_PLATFORM_DIST = 40.0
const PLATFORM_BETWEEN_MIN_DIST = 20.0


var PlatformScenes = [
	preload("res://scenes/ContinueSequence/Platforms/Platform1.tscn"),
	preload("res://scenes/ContinueSequence/Platforms/Platform2.tscn"),
	preload("res://scenes/ContinueSequence/Platforms/Platform3.tscn"),
	preload("res://scenes/ContinueSequence/Platforms/PlatformSphere.tscn"),
]


func _ready() -> void:
	Globals.RingCount = 0
	Globals.LivesCount = 0
	
	CreatePlatforms(Vector3.ZERO)


func _physics_process(delta: float) -> void:
	Killbox.global_position = Player.global_position * Vector3(1, 0, 1)
	

func CreatePlatforms(startPoint: Vector3) -> void:
	var newPlatformCount = randi() % 5 + 2
	
	for i in range(newPlatformCount):
		GeneratePlatform(startPoint)


func GeneratePlatform(startPoint: Vector3, recursion := true) -> void:
	var Direction: Vector3 = Vector3((randf() - 0.5) * 2.0, (randf() - 0.5) * 0.1, (randf() - 0.5) * 2.0).normalized()
	var Distance: float = randf_range(MIN_PLATFORM_DIST, MAX_PLATFORM_DIST)
	
	var FinalPosition = startPoint + (Direction * Distance)
	for i in Platforms.get_children():
		if i.global_position.distance_to(FinalPosition) < PLATFORM_BETWEEN_MIN_DIST:
			#keep platforms from spawning inside each other
			if recursion:
				return GeneratePlatform(startPoint, false)
	
	
	var platformID: int = randi() % PlatformScenes.size()
	
	var newPlatform = PlatformScenes[platformID].instantiate()
	Platforms.add_child(newPlatform)
	newPlatform.global_position = startPoint + (Direction * Distance)
	newPlatform.CreatePlatforms.connect(CreatePlatforms)


func _on_death_timer_timeout() -> void:
	if Globals.LivesCount > 0:
		get_tree().change_scene_to_file(Globals.CurrentScene)
	else:
		get_tree().change_scene_to_file("res://scenes/GameOverScene/GameOverScene.tscn")
