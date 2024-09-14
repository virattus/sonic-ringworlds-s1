extends BasicState


var Accumulator := 0.0


func Enter(_msg := {}) -> void:
	owner.SpriteBit.visible = false
	owner.SpritePop.visible = true
	owner.SetPlayerCollision(false)
	owner.SpawnDefeatSound()


func Exit() -> void:
	Accumulator = 0.0


func Update(_delta: float) -> void:
	Accumulator += _delta
	if Accumulator >= 0.25:
		owner.queue_free()
