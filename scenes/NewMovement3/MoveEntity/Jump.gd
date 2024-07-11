extends BasicState



const JUMP_POWER = 40.0


func Enter(_msg := {}) -> void:
	owner.velocity += owner.up_direction * JUMP_POWER


func Exit() -> void:
	pass


func Update(_delta: float) -> void:
	pass
