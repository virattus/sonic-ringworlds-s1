class_name CharController
extends Node


signal JumpJustPressed
signal JumpJustReleased

signal AttackJustPressed
signal AttackJustReleased


enum {
	BUTTON_JUST_PRESSED,
	BUTTON_PRESSED,
	BUTTON_JUST_RELEASED,
	BUTTON_RELEASED,
}


var InputVelocity := Vector3.ZERO
var InputJump := BUTTON_RELEASED
var InputAttack := BUTTON_RELEASED

