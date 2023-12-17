extends BasicState


var prevState = null

func Enter(_msg := {}) -> void:
	if _msg.has("PrevState"):
		prevState = _msg["PrevState"]


func Exit() -> void:
	pass


func Update(_delta: float) -> void:
	pass


func Resume() -> void:
	ChangeState(prevState)
