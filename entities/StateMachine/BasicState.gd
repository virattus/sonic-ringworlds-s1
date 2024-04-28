class_name BasicState
extends Node


var ParentStateMachine: StateMachine = null


func GetFullName() -> String:
	return name


func ChangeState(newState : String, msg := {}) -> void:
	if get_parent() is ComplexState:
		get_parent().ChangeState(newState, msg)
	else:
		ParentStateMachine.ChangeState(newState, msg)


func ChangeSubState(newState: String, msg := {}) -> void:
	if get_parent() is ComplexState:
		get_parent().ChangeSubState(newState, msg)
	else:
		ChangeState(newState, msg)


func Enter(_msg := {}) -> void:
	pass


func Exit() -> void:
	pass


func Update(_delta: float) -> void:
	pass
