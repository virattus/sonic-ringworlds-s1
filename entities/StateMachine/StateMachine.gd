class_name StateMachine
extends Node


signal StateChange(state_name)


@export var ActiveState : BasicState
var CurrentState : String


func _ready() -> void:
	DebugMenu.AddMonitor(self, "CurrentState")
	
	await(owner.ready)
	
	InitialiseStateMachine()


func _physics_process(delta: float) -> void:
	ActiveState.Update(delta)


func InitialiseStateMachine():
	for i in get_children():
		i.ParentStateMachine = self
	
	CurrentState = ActiveState.name
	ActiveState.Enter()


func ChangeState(newState : String, msg := {}) -> void:
	msg["PrevState"] = ActiveState.name
	
	ActiveState.Exit()
	ActiveState = get_node(newState)
	ActiveState.Enter(msg)
	CurrentState = ActiveState.GetFullName()
	StateChange.emit(CurrentState)
