class_name Character
extends CharacterBody3D


signal HealthChanged(Percentage: float)
signal HealthEmpty

@export var Controller := CharController.new()
@export var Health := 1
@export var MaxHealth := 1

var Speed := 0.0

var GroundCollision := false
var GroundCollisionShape : String

const GROUND_CAST_MIN_DISTANCE = 0.1

@onready var Gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var CharMesh = $CharacterMesh
@onready var WorldCollision: CollisionShape3D = $WorldCollision
@onready var GroundCast: RayCast3D = $GroundCast



func _ready() -> void:
	DebugMenu.AddMonitor(self,"global_position")
	DebugMenu.AddMonitor(self, "velocity")
	DebugMenu.AddMonitor(self, "Speed")
	DebugMenu.AddMonitor(self, "GroundCollision")
	DebugMenu.AddMonitor(self, "GroundCollisionShape")
	DebugMenu.AddMonitor(self, "Health")
	DebugMenu.AddMonitor(self, "MaxHealth")
	
	#This is to fix problems caused by rotating the model in the editor
	#as the controls for the character assume an axis aligned node
	var newRotation = rotation_degrees
	global_transform.basis = Basis.IDENTITY
	CharMesh.rotation_degrees = newRotation


func _process(_delta: float) -> void:
	GroundCollision = is_on_floor() #or (global_position.y - GroundCast.get_collision_point().y < GROUND_CAST_MIN_DISTANCE)
	if GroundCast.is_colliding():
		GroundCollisionShape = GroundCast.get_collider().name
	else:
		GroundCollisionShape = "None"


func ReceiveDamage(hurtbox: Area3D, damage: int) -> void:
	if Health <= 0:
		return
	
	Health = clamp(Health - damage, 0, MaxHealth)
	
	HealthChanged.emit(float(damage) / float(MaxHealth))
	if Health <= 0:
		HealthEmpty.emit()


func Move(newVelocity: Vector3) -> void:
	velocity = newVelocity
	move_and_slide()
	Speed = velocity.length()


func LookAt(target: Vector3) -> void:
	CharMesh.look_at(target)
