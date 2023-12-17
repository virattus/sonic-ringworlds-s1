extends Node3D


@export var Lifespan := 1.0
@export var FadeStartTime := 0.5
@export var ObjCount := 0


@onready var CurrentLife := Lifespan
@onready var ObjTotal := ObjCount


func _process(delta: float) -> void:
	if CurrentLife <= 0.0:
		queue_free()
	elif CurrentLife < FadeStartTime:
		UpdateVisibility(CurrentLife - delta)
	
	CurrentLife -= delta


func UpdateVisibility(newLife) -> void:
	var newCount = round(newLife / (FadeStartTime / ObjTotal))
	if newCount < ObjCount:
		if get_child_count() > 0:
			get_child(0).queue_free()
		else:
			print("AdditiveMeshMultiplier: Tried to free too many objects, this should never appear")
		ObjCount = newCount
