class_name BasicState
extends Node


var ParentStateMachine = null


func ChangeState(newState : String, msg := {}) -> void:
	ParentStateMachine.ChangeState(newState, msg)


func Enter(_msg := {}) -> void:
	pass


func Exit() -> void:
	pass


func Update(_delta: float) -> void:
	pass
