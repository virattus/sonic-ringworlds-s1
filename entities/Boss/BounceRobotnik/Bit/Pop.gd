extends BasicState



func Enter(_msg := {}) -> void:
	owner.SpriteBit.visible = false
	owner.SpriteBit.visible = true


func Exit() -> void:
	pass


func Update(_delta: float) -> void:
	pass
