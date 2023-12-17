class_name MonitorProperty
extends Node

var object
var property
var value
var display
var fullPath

const num_format = "4.2f"


func _init(_object, _property, _display) -> void:
	object = _object
	property = _property
	display = _display
	fullPath = String(object.get_path())


func UpdateValue() -> bool:
	if !is_instance_valid(object):
		return false
	
	var p = object.get_indexed(property)
	match display:
		"":
			value = str(p)
		"length":
			value = num_format % p.length()
		"round":
			match typeof(p):
				TYPE_INT, TYPE_FLOAT:
					value = num_format % p
				TYPE_VECTOR2, TYPE_VECTOR3:
					value = str(p.round())
	
	return true
