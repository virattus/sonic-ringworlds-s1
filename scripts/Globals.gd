extends Node


var DEBUG_SCENES = {
	"ControllerInputTester": "res://scenes/ControllerInputTester/ControllerInputTester.tscn",
	"MovementTesting": "res://scenes/MovementTesting/MovementTesting.tscn",
	"ResortIsland": "res://scenes/R_ResortIsland/ResortIsland.tscn",
	"RadicalCity": "res://scenes/R_RadicalCity/RadicalCity.tscn",
	"RegalRuin": "res://scenes/R_RegalRuin/RegalRuin.tscn",
	"ReactiveFactory": "res://scenes/R_ReactiveFactory/ReactiveFactory.tscn",
	
}
var CurrentScene = null

const DEBUG_FORCE_DASHMODE = true


var WindowedModeScreenSize := Vector2i.ZERO

var PreviousMouseMode := -1


var RingCount := 0
var PlayerChar = null

var InvertCamera := false
