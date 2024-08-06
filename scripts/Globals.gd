extends Node


var DEBUG_SCENES = {
	"ControllerInputTester": "res://scenes/ControllerInputTester/ControllerInputTester.tscn",
	"MovementTesting": "res://scenes/MovementTesting/MovementTesting.tscn",
	"ResortIsland": "res://scenes/R_ResortIsland/ResortIsland.tscn",
	"RadicalCity": "res://scenes/R_RadicalCity/RadicalCity.tscn",
	"RegalRuin": "res://scenes/R_RegalRuin/RegalRuin.tscn",
	"ReactiveFactory": "res://scenes/R_ReactiveFactory/ReactiveFactory.tscn",
	"SA1 Windy Valley Act 3": "res://scenes/SA1_WV_3/SA1_WV_3.tscn",
	"NewMovement": "res://scenes/NewMovement/NewMovement.tscn",
	"MapLoader": "res://scenes/GLTFLoader/GLTFLoader.tscn",
	"SphereTest": "res://scenes/SphereTest/SphereTest.tscn",
}
var CurrentScene = null

const DEBUG_FORCE_DASHMODE = false


var WindowedModeScreenSize := Vector2i.ZERO

var PreviousMouseMode := -1


var RingCount := 0
var LivesCount := 3
var PlayerChar = null

var InvertCamera := false
