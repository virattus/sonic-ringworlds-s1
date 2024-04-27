extends BasicState


@export var ActiveState: BasicState


var StateM: StateMachine = null


func _ready() -> void:
	StateM = StateMachine.new()
	StateM.ActiveState = ActiveState
	add_child(StateM)


func ChangeSubState(newState : String, msg := {}) -> void:
	StateM.ChangeState(newState, msg)
