extends BasicState




func Enter(_msg := {}) -> void:
	owner.SpriteBit.visible = false
	owner.SpritePop.visible = true
	owner.SetPlayerCollision(false)
	owner.SpawnDefeatSound()


func Exit() -> void:
	pass


func Update(_delta: float) -> void:
	pass
