extends Node


var DEBUG_SCENES = {
	"ControllerInputTester": "res://scenes/ControllerInputTester/ControllerInputTester.tscn",
	"MovementTesting": "res://scenes/MovementTesting/MovementTesting.tscn",
}
var CurrentScene = null


var WindowedModeScreenSize := Vector2i.ZERO

var PreviousMouseMode := -1


var PlayerChar = null
