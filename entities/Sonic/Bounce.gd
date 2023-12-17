extends BasicState



var Power := 0.0
var Direction := Vector3.ZERO


const SPEED = 15.0


func Enter(_msg := {}) -> void:
	if _msg.has("Power"):
		Power = _msg["Power"]
	if _msg.has("Direction"):
		Direction = _msg["Direction"]
	else:
		Direction = Vector3.ZERO


func Exit() -> void:
	pass
	

func HandleInput(_event: InputEvent) -> void:
	pass
	

func Update(_delta: float) -> void:
	owner.Move(Direction.normalized() * SPEED)
	
	Power -= _delta
	
	if Power <= 0.0:
		ChangeState("AirMove", {
			"State": "FALL",
		})
		return
