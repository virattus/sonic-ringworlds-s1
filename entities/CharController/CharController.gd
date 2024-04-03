class_name CharController
extends Node


signal JumpJustPressed
signal JumpPressed
signal JumpJustReleased

signal AttackJustPressed
signal AttackPressed
signal AttackJustReleased


enum {
	BUTTON_JUST_PRESSED,
	BUTTON_PRESSED,
	BUTTON_JUST_RELEASED,
	BUTTON_RELEASED,
}


var InputVelocity := Vector3.ZERO
var InputAnalogue := Vector2.ZERO
var InputAnalogueDeadzone := 0.0

var InputJump := BUTTON_RELEASED
var InputAttack := BUTTON_RELEASED

