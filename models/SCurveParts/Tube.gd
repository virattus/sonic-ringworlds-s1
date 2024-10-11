@tool
extends Node3D


@export var Count := 1 :
	set(value):
		Count = value
		if UpdateCount:
			UpdateModelLength()


var UpdateCount := false


const TUBE_SEGMENT = preload("res://models/SCurveParts/TubeStraight.tscn")
const TUBE_LENGTH = 6.0


func _ready() -> void:
	UpdateCount = true
	UpdateModelLength()
	


func UpdateModelLength() -> void:
	for i in get_children():
		i.queue_free()
	
	for i in range(Count):
		var newSegment = TUBE_SEGMENT.instantiate()
		add_child(newSegment)
		newSegment.position.x = TUBE_LENGTH * i
