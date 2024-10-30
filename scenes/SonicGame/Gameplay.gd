extends BasicState





func Enter(_msg := {}) -> void:
	owner.player.StateM.ChangeState("Idle")
	
	for i in owner.enemies.get_children():
		i.StateM.ChangeState("Idle")


func Exit() -> void:
	pass


func Update(_delta: float) -> void:
	pass
