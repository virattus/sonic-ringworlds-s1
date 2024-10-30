class_name ComplexState
extends BasicState


signal StateChange(state_name)

@export var ActiveState: BasicState
var CurrentState : String


func _ready() -> void:
	await(owner.ready)
	
	InitialiseStateMachine()


func GetFullName() -> String:
	return name + str("->") + ActiveState.GetFullName()


func InitialiseStateMachine() -> void:
	for i in get_children():
		i.ParentStateMachine = self
	
	CurrentState = ActiveState.name
	ActiveState.Enter()


func ChangeSubState(newState : String, msg := {}) -> void:
	msg["PrevState"] = ActiveState.name
	
	ActiveState.Exit()
	ActiveState = get_node(newState)
	ActiveState.Enter(msg)
	CurrentState = ActiveState.GetFullName()
	StateChange.emit(CurrentState)


func Enter(_msg := {}) -> void:
	if _msg.has("SubState"):
		ChangeSubState(_msg["SubState"], _msg)
	
	ActiveState.Enter(_msg)


func Exit() -> void:
	ActiveState.Exit()


func Update(_delta: float) -> void:
	ActiveState.Update(_delta)
